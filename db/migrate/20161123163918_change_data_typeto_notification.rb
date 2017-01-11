class ChangeDataTypetoNotification < ActiveRecord::Migration[5.0]
  def change
    change_column :notifications, :same_as, 'json USING CAST(notifications AS json)'
  end
end
