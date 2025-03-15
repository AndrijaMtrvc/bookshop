module Admin
  class BooksController < ApplicationController
    before_action :require_login
    before_action :ensure_admin
    before_action :set_book, only: [:edit, :update]

    def index
      @books = Book.all
      @genres = Book.distinct.pluck(:genre)
      @authors = Book.distinct.pluck(:author)
      if params[:search].present?
        @books = @books.where("title LIKE ? OR author LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
      if params[:genres].present?
        @books = @books.where(genre: params[:genres])
      end
      if params[:authors].present?
        @books = @books.where(author: params[:authors])
      end
      case params[:sort]
      when "price_low_to_high"
        @books = @books.order(price: :asc)
      when "price_high_to_low"
        @books = @books.order(price: :desc)
      when "author_a_to_z"
        @books = @books.order(author: :asc)
      when "author_z_to_a"
        @books = @books.order(author: :desc)
      when "title_a_to_z"
        @books = @books.order(title: :asc)
      when "title_z_to_a"
        @books = @books.order(title: :desc)
      end
    end

    def edit
    end

    def update
      if @book.update(book_params)
        redirect_to admin_path, notice: "Book updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
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
      params.require(:book).permit(:title, :author, :genre, :price, :image_url, :stock, :description)
    end
  end
end