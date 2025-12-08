class ChangeCleartimeTypeInRecords < ActiveRecord::Migration[6.1]
  def change
    change_column(:records, :cleartime, :integer, using: 'EXTRACT(EPOCH FROM cleartime)::integer')
  end
end
