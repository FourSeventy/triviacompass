class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|

      t.integer :bar_id
      t.integer :rating
      t.string :ip

      t.timestamps null: false
    end
  end
end
