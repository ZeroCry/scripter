class AddThemeToScript < ActiveRecord::Migration
  def change
    add_column :script, :theme_string, :string
  end
end
