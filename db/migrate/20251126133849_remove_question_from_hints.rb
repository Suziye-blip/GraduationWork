class RemoveQuestionFromHints < ActiveRecord::Migration[6.1]
  def change
    remove_column :hints, :question, :string
  end
end
