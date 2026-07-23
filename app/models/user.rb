class User < ApplicationRecord
  ROLES = {
    student: 0,
    instructor: 1,
    admin: 2
  }.freeze

  PASSWORD_REGEXP = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.{8,}).+\z/

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, ROLES

  validates :password, format: { with: PASSWORD_REGEXP }, if: :password_required?

  validates :role, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[email created_at role]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
