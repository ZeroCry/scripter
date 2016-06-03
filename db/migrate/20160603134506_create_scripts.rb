class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :code
      t.string :slug
      t.string :language
      t.string :theme_string
      t.timestamps null: false
    end
  end
end
