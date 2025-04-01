# db/seeds.rb
require "open-uri"

# Počisti obstoječe podatke (opcijsko, če želiš svež začetek)
Book.destroy_all
Author.destroy_all
Genre.destroy_all

# Dodaj avtorje
authors = [
  Author.create!(name: "J.K. Rowling"),
  Author.create!(name: "George R.R. Martin"),
  Author.create!(name: "Agatha Christie"),
  Author.create!(name: "J.R.R. Tolkien")
]

# Dodaj žanre
genres = [
  Genre.create!(name: "Fantasy"),
  Genre.create!(name: "Mystery"),
  Genre.create!(name: "Adventure")
]

# URL-ji slik
image_urls = [
  "https://m.media-amazon.com/images/I/81q77Q39nEL.jpg", # Harry Potter
  "https://m.media-amazon.com/images/I/71Jzezm8CBL.jpg", # A Game of Thrones
  "https://m.media-amazon.com/images/I/71ihbKf67RL.jpg", # Murder on the Orient Express
  "https://m.media-amazon.com/images/I/712cDO7d73L.jpg"  # The Hobbit
]

# Dodaj knjige
books = [
  Book.create!(
    title: "Harry Potter and the Philosopher's Stone",
    author: authors[0], # J.K. Rowling
    genre: genres[0],   # Fantasy
    price: 19.99,
    stock: 10,
    description: "A young wizard's journey begins!"
  ),
  Book.create!(
    title: "A Game of Thrones",
    author: authors[1], # George R.R. Martin
    genre: genres[0],   # Fantasy
    price: 29.99,
    stock: 5,
    description: "Epic tale of kings and dragons."
  ),
  Book.create!(
    title: "Murder on the Orient Express",
    author: authors[2], # Agatha Christie
    genre: genres[1],   # Mystery
    price: 15.99,
    stock: 8,
    description: "A classic whodunit on a train."
  ),
  Book.create!(
    title: "The Hobbit",
    author: authors[3], # J.R.R. Tolkien
    genre: genres[2],   # Adventure
    price: 22.50,
    stock: 7,
    description: "An unexpected journey with hobbits."
  )
]

# Priloži slike knjigam z Active Storage
books.each_with_index do |book, index|
  begin
    # Prenesi sliko iz URL-ja
    file = URI.open(image_urls[index])
    # Priloži sliko z Active Storage
    book.image.attach(
      io: file,
      filename: "#{book.title.parameterize}.jpg",
      content_type: "image/jpeg"
    )
    puts "Attached image to #{book.title}"
  rescue OpenURI::HTTPError => e
    puts "Failed to download image for #{book.title}: #{e.message}"
  rescue StandardError => e
    puts "Error attaching image to #{book.title}: #{e.message}"
  end
end

# Dodaj admin uporabnika
User.create!(
  first_name: "Andrija",
  last_name: "Mitrović",
  email_address: "andrija.mitrovic@scv.si",
  password: "bXum6A07IH5",
  status: "admin"
)

puts "Seeded user Andrija Mitrović."
puts "Seeded #{authors.count} authors, #{genres.count} genres, and #{books.count} books."