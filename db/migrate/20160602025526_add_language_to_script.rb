class AddLanguageToScript < ActiveRecord::Migration
  def change
    add_column :script, :language, :string
  end
end
