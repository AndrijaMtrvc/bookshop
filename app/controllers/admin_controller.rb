# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  before_action :require_login
  before_action :ensure_admin

  def index
    @books = Book.includes(:author, :genre).all
    @genres = Genre.order(:name) # Namesto Book.distinct.pluck(:genre)
    @authors = Author.order(:name) # Namesto Book.distinct.pluck(:author)

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

  private

  def require_login
    redirect_to new_session_path, alert: "Please sign in first!" unless session[:user_id] && current_user
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied! Admins only." unless current_user.status == "admin"
  end
end