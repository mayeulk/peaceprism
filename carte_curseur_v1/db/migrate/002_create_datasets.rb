class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.string :configuration_file
      t.string :data_file_name
      t.string :data_set_full_name
      t.string :data_set_short_name
      t.text :data_set_citation
      t.string :unit_of_analysis
      t.integer :first_year_possible
      t.integer :last_year_possible
      t.boolean :label_line_in_data_file
      t.integer :number_of_variables
      t.integer :number_of_cases

      t.timestamps
    end
  end

  def self.down
    drop_table :datasets
  end
end
