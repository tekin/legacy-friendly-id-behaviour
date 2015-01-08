class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :owner_id
      t.string :slug

      t.timestamps
    end
  end
end
