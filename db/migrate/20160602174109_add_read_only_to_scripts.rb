class AddReadOnlyToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :read_only, :bit
  end
end
