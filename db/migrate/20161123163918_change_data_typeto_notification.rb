class ChangeDataTypetoNotification < ActiveRecord::Migration[5.0]
  def change
    change_column :notifications, :same_as,  :json
  end
end
