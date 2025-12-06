class ChangeCleartimeTypeInRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :records, :cleartime, :integer
  end
end
