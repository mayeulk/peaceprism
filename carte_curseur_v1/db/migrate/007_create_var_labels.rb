class CreateVarLabels < ActiveRecord::Migration
  def self.up
    create_table :var_labels do |t|
      t.integer :var_key
      t.integer :var_id
      t.integer :dataset_id
      t.integer :value
      t.string :meaning
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :var_labels
  end
end
