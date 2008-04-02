class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      t.integer :dataset_id
      t.string :name
      t.string :type
      t.string :kind
      t.string :reverse
      t.string :missing

      t.timestamps
    end
  end

  def self.down
    drop_table :variables
  end
end
