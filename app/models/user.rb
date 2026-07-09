class User < ApplicationRecord
  ROLES = {
    student: 0,
    instructor: 1,
    admin: 2
  }.freeze

  PASSWORD_REGEXP = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.{8,}).+\z/

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, ROLES

  validates :email,
          presence: true,
          uniqueness: { case_sensitive: false },
          format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, format: { with: PASSWORD_REGEXP }, if: :password_required?

  validates :role, presence: true
end
