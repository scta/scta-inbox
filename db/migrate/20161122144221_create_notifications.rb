class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :source
      t.string :object
      t.string :target
      t.timestamp :updated

      t.timestamps
    end
  end
end
