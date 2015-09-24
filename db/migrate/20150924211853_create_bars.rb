class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.time :trivia_time
      t.string :trivia_day

      t.timestamps null: false
    end
  end
end
