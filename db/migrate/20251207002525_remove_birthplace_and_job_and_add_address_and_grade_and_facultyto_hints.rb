class RemoveBirthplaceAndJobAndAddAddressAndGradeAndFacultytoHints < ActiveRecord::Migration[6.0]
  def change
    remove_column :hints, :birthplace, :string
    remove_column :hints, :job, :string

    add_column :hints, :address, :string
    add_column :hints, :grade, :string
    add_column :hints, :faculty, :string
  end
end