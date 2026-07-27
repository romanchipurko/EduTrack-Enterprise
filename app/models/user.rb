class User < ApplicationRecord
  ROLES = {
    student: 0,
    instructor: 1,
    admin: 2
  }.freeze

  PASSWORD_REGEXP = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.{8,}).+\z/

  has_many :quiz_attempts, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, ROLES

  validates :password, format: { with: PASSWORD_REGEXP }, if: :password_required?

  validates :role, presence: true

  def self.dashboard_counts
    Rails.cache.fetch("dashboard/user_counts", expires_in: 5.minutes) do
      roles_counts = User.group(:role).count
      roles_counts.default = 0

      {
        total: roles_counts.values.sum,
        students: roles_counts["student"],
        instructors: roles_counts["instructor"],
        admins: roles_counts["admin"]
      }
    end
  end

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
