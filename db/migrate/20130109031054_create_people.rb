class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :surname
      t.string :given_names
      t.string :street_name
      t.string :postcode
      t.string :suburb

      t.timestamps
    end
  end
end
