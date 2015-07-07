class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :str
      t.text :txt
      t.date :date
      t.integer :int
      t.boolean :bol
      t.string :not_null, null: false

      t.integer :parent_id

      t.timestamps
    end
  end
end
