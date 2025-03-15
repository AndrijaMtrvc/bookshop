Book.destroy_all
User.destroy_all

# Uporabnik Andrija Mitrović
User.create!(
  email_address: "andrija.mitrovic@scv.si",
  password: "bXum6A07IH5",
  password_confirmation: "bXum6A07IH5",
  first_name: "Andrija",
  last_name: "Mitrović",
  status: "admin" # Privzeto, spremeni v "admin" prek konzole, če želiš
)

# Dejanske knjige
books = [
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    genre: "Fiction",
    price: 10.99,
    stock: 15,
    image_url: "https://m.media-amazon.com/images/I/51IXWZzlgSL._SY445_SX342_.jpg",
    description: "A gripping, heart-wrenching, and wholly remarkable tale of coming-of-age in a South poisoned by virulent prejudice."
  },
  {
    title: "1984",
    author: "George Orwell",
    genre: "Sci-Fi",
    price: 8.99,
    stock: 20,
    image_url: "https://m.media-amazon.com/images/I/7180qjGSgDL._AC_UY327_FMwebp_QL65_.jpg",
    description: "A dystopian novel set in a totalitarian society under constant surveillance, where independent thinking is a crime."
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    genre: "Romance",
    price: 7.50,
    stock: 12,
    image_url: "https://m.media-amazon.com/images/I/81NLDvyAHrL._AC_UY327_FMwebp_QL65_.jpg",
    description: "A classic romance novel exploring love, class, and societal expectations through the spirited Elizabeth Bennet."
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    price: 12.99,
    stock: 10,
    image_url: "https://m.media-amazon.com/images/I/712cDO7d73L._AC_UY327_FMwebp_QL65_.jpg",
    description: "A fantasy adventure following Bilbo Baggins as he embarks on a quest to reclaim a lost dwarf kingdom."
  },
  {
    title: "Sapiens: A Brief History of Humankind",
    author: "Yuval Noah Harari",
    genre: "Non-Fiction",
    price: 15.99,
    stock: 8,
    image_url: "https://images-na.ssl-images-amazon.com/images/I/713jIoMO3UL.jpg",
    description: "A thought-provoking exploration of the history of humankind, from the Stone Age to the modern era."
  }
]

books.each do |book|
  Book.create!(book)
end

puts "Seeded 1 user (Andrija Mitrović) and 5 real books."