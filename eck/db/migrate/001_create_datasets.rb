class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.integer :baseid_pb
      t.string :name
      t.text :description
      t.text :temporaldomain
      t.text :spatialdomain
      t.text :typeofevent
      t.text :definitionofevent
      t.text :violencethreshold
      t.text :datacoded
      t.text :principalresearcher
      t.text :accesstoinformation
      t.text :url
      t.boolean :recherche_commencee
      t.boolean :recherche_finie
      t.string :manque_info_importantes
      t.string :debut
      t.string :fin
      t.timestamps
    end
    
    create_table :researchers do |t|
      t.string :name
      t.string :first_name
      t.string :email
      t.string :comment
      t.timestamps
    end

    create_table(:dataset_researchers, :id => false) do |t|
      t.integer :dataset_id
      t.integer :baseid_pb
      t.integer :researcher_id
      t.timestamps
    end


    
  end

  def self.down
    drop_table :datasets
    drop_table :researchers
    drop_table :dataset_researchers
  end
end
