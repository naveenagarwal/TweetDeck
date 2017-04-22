class Profile < ApplicationRecord
  belongs_to :user
  has_many :posts

  validates :provider, :token, :secret, presence: true

  validates :provider, uniqueness: {
              scope: :user_id,
              message: "Already signed up"
            }
end
