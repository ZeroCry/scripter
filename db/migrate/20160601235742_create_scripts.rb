class CreateScripts < ActiveRecord::Migration
  def change
    create_table :script do |t|
      t.string :name
      t.text :code
      t.string :slug
      t.timestamps null: false
    end
  end
end
