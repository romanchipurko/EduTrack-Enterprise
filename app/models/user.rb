class User < ApplicationRecord
  ROLES = {
    student: 0,
    instructor: 1,
    admin: 2
  }.freeze

  devise :database_authenticatable, :registerable, :recoverable, :rememberable

  enum :role, ROLES

  validates :email,
          presence: true,
          uniqueness: { case_sensitive: false },
          format: { with: /\A[\w+\-.]+@[a-z\d]+([-.][a-z\d]+)*\.[a-z]{2,}\z/i }

  validates :password,
          presence: true,
          confirmation: true,
          format: { with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.{8,}).+\z/ },
          if: :required_password?

  validates :role, presence: true

  private

  def required_password?
    !persisted? || password.present? || password_confirmation.present?
  end
end
