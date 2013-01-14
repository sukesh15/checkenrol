class AddOrgToPerson < ActiveRecord::Migration
  def change
    add_column :people, :organisation, :string
  end
end
