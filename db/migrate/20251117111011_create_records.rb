class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.integer :user_id,null:false,foreign_key: true
      t.integer :number_of_time
      t.time :cleartime
      t.boolean :giveup

      t.timestamps
    end
  end
end
