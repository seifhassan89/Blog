class User < ApplicationRecord
  belongs_to :role
  has_many :comments
  has_many :posts
end
