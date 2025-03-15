class HomeController < ApplicationController
    def index
      # Best of the Week: 3 naključne knjige
      @best_of_the_week = Book.order("RANDOM()").limit(3)
  
      # Author of the Week: Naključni avtor in ena njegova knjiga
      all_authors = Book.pluck(:author).uniq.compact # Pridobimo vse avtorje
      @author_of_the_week = all_authors.sample # Izberemo naključnega avtorja
      @author_book = Book.where(author: @author_of_the_week).order("RANDOM()").first if @author_of_the_week
    end
  end