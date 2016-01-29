class AddEmailSubscribingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_subscribed, :boolean, :default => true
  end
end
