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

# Podatki za knjige
book_data = [
  {
    title: "Harry Potter and the Philosopher's Stone",
    author: authors[0], # J.K. Rowling
    genre: genres[0],   # Fantasy
    price: 19.99,
    stock: 10,
    description: "A young wizard's journey begins!",
    image_url: "https://m.media-amazon.com/images/I/81q77Q39nEL.jpg"
  },
  {
    title: "A Game of Thrones",
    author: authors[1], # George R.R. Martin
    genre: genres[0],   # Fantasy
    price: 29.99,
    stock: 5,
    description: "Epic tale of kings and dragons.",
    image_url: "https://m.media-amazon.com/images/I/71Jzezm8CBL.jpg"
  },
  {
    title: "Murder on the Orient Express",
    author: authors[2], # Agatha Christie
    genre: genres[1],   # Mystery
    price: 15.99,
    stock: 8,
    description: "A classic whodunit on a train.",
    image_url: "https://m.media-amazon.com/images/I/71ihbKf67RL.jpg"
  },
  {
    title: "The Hobbit",
    author: authors[3], # J.R.R. Tolkien
    genre: genres[2],   # Adventure
    price: 22.50,
    stock: 7,
    description: "An unexpected journey with hobbits.",
    image_url: "https://m.media-amazon.com/images/I/712cDO7d73L.jpg"
  }
]

# Ustvari knjige in priloži slike
books = []
book_data.each do |data|
  begin
    # Ustvari knjigo brez shranjevanja v bazo
    book = Book.new(
      title: data[:title],
      author: data[:author],
      genre: data[:genre],
      price: data[:price],
      stock: data[:stock],
      description: data[:description]
    )

    # Prenesi sliko iz URL-ja
    file = URI.open(data[:image_url])
    book.image.attach(
      io: file,
      filename: "#{book.title.parameterize}.jpg",
      content_type: "image/jpeg"
    )
    puts "Attached image to #{book.title}"

    # Shrani knjigo v bazo šele po prilaganju slike
    book.save!
    books << book
  rescue OpenURI::HTTPError => e
    puts "Failed to download image for #{data[:title]}: #{e.message}"
    # Shrani knjigo brez slike, če validacija to dopušča
    book.save(validate: false) if book
    books << book if book
  rescue StandardError => e
    puts "Error processing #{data[:title]}: #{e.message}"
    # Shrani knjigo brez slike, če validacija to dopušča
    book.save(validate: false) if book
    books << book if book
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