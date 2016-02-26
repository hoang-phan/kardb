class AddPositionToLines < ActiveRecord::Migration
  def change
    add_column :lines, :position, :integer, default: 0
  end
end
