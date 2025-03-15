# app/controllers/admin_controller.rb
class AdminController < ApplicationController
    before_action :require_login
    before_action :ensure_admin
  
    def index
      @books = Book.all
      @genres = Book.distinct.pluck(:genre).sort
      @authors = Book.distinct.pluck(:author).sort
  
      if params[:search].present?
        @books = @books.where("title ILIKE ? OR author ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
  
      @books = @books.where(genre: params[:genres]) if params[:genres].present?
      @books = @books.where(author: params[:authors]) if params[:authors].present?
  
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
  
    private
  
    def require_login
      redirect_to new_session_path, alert: "Please sign in first!" unless session[:user_id] && current_user
    end
  
    def ensure_admin
      redirect_to root_path, alert: "Access denied! Admins only." unless current_user.status == "admin"
    end
  end