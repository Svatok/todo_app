class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  include DeviseTokenAuth::Concerns::User
  has_many :todos
end
