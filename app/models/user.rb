class User < ApplicationRecord
  validates :email_address, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :status, inclusion: { in: %w[regular admin] }
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?

  has_secure_password
end