class AddSameAsToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :same_as, :string
  end
end
