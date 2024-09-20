class Post < ApplicationRecord
  belongs_to :user, class_name: "User"
  has_many :comment, foreign_key: :post_id, dependent: :destroy
  has_and_belongs_to_many :tags
end
