class CreateHints < ActiveRecord::Migration[6.1]
  def change
    create_table :hints do |t|
      t.string :name,null:false
      t.string :gender,null:false
      t.integer :age,null:false
      t.string :birthplace,null:false
      t.string :job,null:false

      t.timestamps
    end
  end
end
