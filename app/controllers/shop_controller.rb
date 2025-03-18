class ShopController < ApplicationController
  def index
    @books = Book.includes(:author, :genre).all # Naloži povezane avtorje in žanre

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @books = @books.joins(:author).where("LOWER(books.title) LIKE ? OR LOWER(authors.name) LIKE ?", search_term, search_term)
    end

    if params[:genres].present? && params[:genres].reject(&:blank?).any?
      @books = @books.where(genre_id: params[:genres].reject(&:blank?))
    end
    if params[:authors].present? && params[:authors].reject(&:blank?).any?
      @books = @books.where(author_id: params[:authors].reject(&:blank?))
    end

    case params[:sort]
    when "price_low_to_high"
      @books = @books.order(price: :asc)
    when "price_high_to_low"
      @books = @books.order(price: :desc)
    when "author_a_to_z"
      @books = @books.joins(:author).order("authors.name ASC")
    when "author_z_to_a"
      @books = @books.joins(:author).order("authors.name DESC")
    when "title_a_to_z"
      @books = @books.order(title: :asc)
    when "title_z_to_a"
      @books = @books.order(title: :desc)
    end

    @authors = Author.order(:name) # Pridobi avtorje iz tabele authors
    @genres = Genre.order(:name) # Pridobi žanre iz tabele genres
  end

  def show
    @book = Book.find(params[:id])
    @cart = session[:cart] || {}
    @quantity_in_cart = @cart[@book.id.to_s] || 0
  end

  def cart
    @cart = session[:cart] || {}
    @cart_items = Book.where(id: @cart.keys).map do |book|
      { book: book, quantity: @cart[book.id.to_s] }
    end
  end

  def add_to_cart
    @book = Book.find(params[:id])
    @cart = session[:cart] || {}
    current_quantity = @cart[@book.id.to_s].to_i
    quantity_to_add = params[:quantity].to_i
    available_stock = @book.stock - current_quantity

    if quantity_to_add > 0 && quantity_to_add <= available_stock
      @cart[@book.id.to_s] = current_quantity + quantity_to_add
      session[:cart] = @cart
      redirect_to cart_shop_index_path, notice: "#{quantity_to_add} #{@book.title} added to your cart!"
    else
      redirect_to shop_path(@book), alert: "Sorry, cannot add #{quantity_to_add} #{@book.title}. Only #{available_stock} left in stock!"
    end
  end

  def update_cart
    @cart = session[:cart] || {}
    book_id = params[:book_id]
    new_quantity = params[:quantity].to_i
    book = Book.find(book_id)

    if new_quantity > 0 && new_quantity <= book.stock
      @cart[book_id] = new_quantity
    elsif new_quantity <= 0
      @cart.delete(book_id)
    end
    session[:cart] = @cart
    redirect_to cart_shop_index_path, notice: "Cart updated!"
  end

  def remove_from_cart
    @cart = session[:cart] || {}
    book_id = params[:book_id]
    @cart.delete(book_id)
    session[:cart] = @cart
    redirect_to cart_shop_index_path, notice: "Item removed from cart!"
  end

  def clear_cart
    session[:cart] = {}
    redirect_to cart_shop_index_path, notice: "Cart cleared!"
  end
end