class Book < ApplicationRecord
  belongs_to :author
  belongs_to :genre
  has_one_attached :image # Dodaj to vrstico za eno sliko na knjigo
  validates :title, :price, :stock, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end