module Admin
  class BooksController < ApplicationController
    before_action :require_login
    before_action :ensure_admin
    before_action :set_book, only: [:edit, :update, :destroy]

    def index
      @books = Book.includes(:author, :genre).all # Dodan includes za učinkovitost
      @genres = Genre.order(:name) # Razvrščeno po imenu
      @authors = Author.order(:name) # Razvrščeno po imenu

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
    end

    def new
      @book = Book.new
      @authors = Author.order(:name) # Razvrščeno po imenu
      @genres = Genre.order(:name) # Razvrščeno po imenu
    end

    def create
      @book = Book.new(book_params)
      if @book.save
        redirect_to admin_path, notice: "Book added successfully!"
      else
        @authors = Author.order(:name)
        @genres = Genre.order(:name)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @authors = Author.order(:name) # Razvrščeno po imenu
      @genres = Genre.order(:name) # Razvrščeno po imenu
    end

    def update
      if @book.update(book_params)
        redirect_to admin_path, notice: "Book updated successfully!"
      else
        @authors = Author.order(:name)
        @genres = Genre.order(:name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @book.destroy
      redirect_to admin_path, notice: "Book was successfully deleted."
    end

    private

    def require_login
      redirect_to new_session_path, alert: "Please sign in first!" unless session[:user_id] && current_user
    end

    def ensure_admin
      redirect_to root_path, alert: "Access denied! Admins only." unless current_user.status == "admin"
    end

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author_id, :genre_id, :price, :image_url, :stock, :description)
    end
  end
end