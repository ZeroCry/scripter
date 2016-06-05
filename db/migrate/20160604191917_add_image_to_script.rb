class AddImageToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :image, :string
  end
end
