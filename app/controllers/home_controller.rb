# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    # Best of the Week: 3 naključne knjige
    @best_of_the_week = Book.includes(:author, :genre).order("RANDOM()").limit(3)

    # Author of the Week: Naključni avtor in ena njegova knjiga
    @author_of_the_week = Author.order("RANDOM()").first
    if @author_of_the_week
      @author_book = Book.includes(:author, :genre)
                         .where(author_id: @author_of_the_week.id)
                         .order("RANDOM()")
                         .first
    end
  end
end