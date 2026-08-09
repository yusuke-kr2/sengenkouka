class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    validates :name, presence: true

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :omniauthable, omniauth_providers: [:google_oauth2]

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
      end
    end

    has_many :declarations, dependent: :destroy
    has_many :witnesses, dependent: :destroy
    has_one_attached :avatar

    has_many :notifications, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "following_id", dependent: :destroy
    has_many :followings, through: :active_relationships, source: :following
    has_many :followers, through: :passive_relationships, source: :follower

    def follow(user)
      followings << user unless self == user || following?(user)
    end

    def unfollow(user)
      active_relationships.find_by(following_id: user.id)&.destroy
    end

    def following?(user)
      followings.include?(user)
    end

    def increment_streak!
      increment!(:streak_count)
    end
end
