class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  def build_heatmap_data(user)
    start_date = 365.days.ago.to_date
    declarations = user.declarations.where("created_at >= ?", start_date)

    data = {}
    declarations.each do |d|
      date = d.created_at.to_date.to_s
      existing = data[date]
      if existing.nil? || heatmap_priority(d.status) > heatmap_priority(existing)
        data[date] = d.status
      end
    end
    data
  end

  def heatmap_priority(status)
    case status
    when "completed" then 2
    when "declaring" then 1
    else 0
    end
  end
end
