class User < ApplicationRecord
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable)

  enum :role, { author: 0, admin: 1 }

  has_many :posts, dependent: :destroy
end
