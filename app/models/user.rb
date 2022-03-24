class User < ApplicationRecord
  has_secure_password

  has_many :ideas, dependent: :nullify
  has_many :reviews, dependent: :nullify

  validates :email, presence: true, uniqueness: true,
    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # where I got this regex - https://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex

  def full_name
    "#{first_name} #{last_name}"
  end
end
