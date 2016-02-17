class AddIndexesToPatches < ActiveRecord::Migration
  def change
    add_index :patches, :version, unique: true
  end
end
