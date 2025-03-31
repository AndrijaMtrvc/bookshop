# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  before_action :require_login
  before_action :ensure_admin

  # Akcija index je premaknjena v Admin::BooksController
  # Tukaj lahko dodaš druge admin akcije, če jih potrebuješ (npr. za upravljanje uporabnikov, statistiko itd.)

  private

  def require_login
    redirect_to new_session_path, alert: "Please sign in first!" unless session[:user_id] && current_user
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied! Admins only." unless current_user.status == "admin"
  end
end