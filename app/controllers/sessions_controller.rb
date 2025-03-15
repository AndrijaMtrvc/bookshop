class SessionsController < ApplicationController
    def new
    end
  
    def create
      user = User.find_by(email_address: params[:email_address])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: "Logged in successfully, #{user.first_name} #{user.last_name}!"
      else
        flash.now[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out!"
    end
  end