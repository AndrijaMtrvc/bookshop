class AddDescriptionToBooks < ActiveRecord::Migration[7.0] # različica Railsa se lahko razlikuje
  def change
    add_column :books, :description, :text
  end
end