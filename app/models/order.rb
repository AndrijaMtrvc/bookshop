class Order < ApplicationRecord
    belongs_to :user, optional: true # Uporabnik je opcijski, če ni prijavljen
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_number, presence: true
    validates :address, presence: true
    validates :status, presence: true
  end