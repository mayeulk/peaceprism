class AddVariableIndex < ActiveRecord::Migration
  def self.up
    add_index(:variables, [:var_id, :dataset_id], :unique => true, :name => 'var_id_dataset_id_index') 
#    add_index(:accounts, [:branch_id, :party_id], :unique => true, :name => 'by_branch_party')

    # , :unique => true)
  end

  def self.down
    remove_index(:variables, :column => [:var_id, :dataset_id])
  end
end
