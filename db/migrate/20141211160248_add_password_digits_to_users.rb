class AddPasswordDigitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digits, :string
  end
end
