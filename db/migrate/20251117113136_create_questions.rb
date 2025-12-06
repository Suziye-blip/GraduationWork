class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :user_id,null:false,foreign_key: true
      t.integer :hint_id,null:false,foreign_key: true
      t.string :subject,null:false
      t.string :predicate,null:false

      t.timestamps
    end
  end
end
