class Book < ApplicationRecord
  belongs_to :author
  belongs_to :genre
  has_one_attached :image # Priloga za sliko

  validates :title, :price, :stock, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Validacija za sliko (opcijsko)
  validates :image, presence: true, on: :create # Zahteva sliko ob ustvarjanju
  validate :image_format, if: -> { image.attached? }

  private

  def image_format
    unless image.content_type.in?(%w[image/jpeg image/png])
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end