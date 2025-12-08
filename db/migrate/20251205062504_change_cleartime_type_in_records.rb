class ChangeCleartimeTypeInRecords < ActiveRecord::Migration[7.0]
  def up
    change_column :records, :cleartime, :integer, using: 'cleartime::integer'
  end

  def down
    change_column :records, :cleartime, :time
  end
end
