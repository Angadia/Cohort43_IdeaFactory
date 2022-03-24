class Idea < ApplicationRecord
  belongs_to :user

  has_many :reviews, -> { order('created_at DESC') }, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 5 }
end
