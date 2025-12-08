class ChangeCleartimeTypeInRecords < ActiveRecord::Migration[6.1]
  def up
    change_column :records, :cleartime, :integer, using: 'cleartime::integer'
  end

  def down
    change_column :records, :cleartime, :time
  end
end
