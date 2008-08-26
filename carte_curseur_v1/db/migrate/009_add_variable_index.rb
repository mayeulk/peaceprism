class AddVariableIndex < ActiveRecord::Migration
  def self.up
    add_index(:variables, [:var_id, :dataset_id], :unique => true) 
  end

  def self.down
    remove_index(:variables, :column => [:var_id, :dataset_id])
  end
end
