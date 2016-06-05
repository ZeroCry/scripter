class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :language
      t.string :name
      t.string :extension_file
      t.string :command

      t.timestamps null: false
    end
  end
end
