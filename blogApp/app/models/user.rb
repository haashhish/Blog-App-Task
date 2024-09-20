class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true #to make sure that emails are unique
  validates :password, presence: true
  has_many :posts, foreign_key: :user_id # 1 to many relationship
  has_many :comments, foreign_key: :user_id # 1 to many relationship
end
