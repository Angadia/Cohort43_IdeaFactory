class Review < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  before_validation :squeeze_strip_whitespaces

  validates :body, presence: true, length: { minimum: 1 }

  private

  def squeeze_strip_whitespaces
    body.squeeze(' ').strip
  end
end
