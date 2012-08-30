class ChangeConfigurableValueTypeToText < ActiveRecord::Migration
  def up
    change_column :configurables, :value, :text
  end

  def down
    change_column :configurables, :value, :string
  end
end
