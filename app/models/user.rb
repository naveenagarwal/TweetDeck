class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # devise :database_authenticatable, :trackable, :rememberable

  has_many :posts
  has_many :profiles
  has_many :documents

  def profile(provider)
    profiles.where(provider: provider).first
  end
end
