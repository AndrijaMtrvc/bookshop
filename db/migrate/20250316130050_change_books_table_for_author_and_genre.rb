class ChangeBooksTableForAuthorAndGenre < ActiveRecord::Migration[8.0]
  def change
    # Dodaj stolpca kot nullable (brez null: false)
    add_reference :books, :author, foreign_key: true
    add_reference :books, :genre, foreign_key: true

    # Prenesi avtorje v tabelo authors
    Book.distinct.pluck(:author).each do |author_name|
      next if author_name.blank?
      author = Author.find_or_create_by(name: author_name)
      Book.where(author: author_name).update_all(author_id: author.id)
    end

    # Prenesi žanre v tabelo genres
    Book.distinct.pluck(:genre).each do |genre_name|
      next if genre_name.blank?
      genre = Genre.find_or_create_by(name: genre_name)
      Book.where(genre: genre_name).update_all(genre_id: genre.id)
    end

    # Po uspešnem prenosu odstrani stare stolpce
    remove_column :books, :author, :string
    remove_column :books, :genre, :string

    # Spremeni stolpca v null: false
    change_column_null :books, :author_id, false
    change_column_null :books, :genre_id, false
  end
end