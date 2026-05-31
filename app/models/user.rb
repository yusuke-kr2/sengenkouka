class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    validates :name, presence: true

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :declarations, dependent: :destroy
    has_one_attached :avatar

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
end
