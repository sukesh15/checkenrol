class AddFurtherAddressDetails < ActiveRecord::Migration
  def change
    add_column :people, :flat_number, :string
    add_column :people, :street_number, :string
    add_column :people, :street_type, :string
  end
end
