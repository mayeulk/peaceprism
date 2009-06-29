class AddColumnsFr < ActiveRecord::Migration
  def self.up
    add_column(:datasets, :description, :text)
    add_column(:datasets, :description_fr, :text)
    add_column(:datasets, :data_set_short_name_fr, :string)
    add_column(:variables, :name_fr, :string)
    add_column(:variables, :unit_fr, :string)
    add_column(:var_labels, :meaning_fr, :string)
    add_column(:var_labels, :description_fr, :text)
  end

  def self.down
     remove_column(:datasets, :description)
     remove_column(:datasets, :description_fr)
     remove_column(:datasets, :data_set_short_name_fr)
     remove_column(:variables, :name_fr)
     remove_column(:variables, :unit_fr)
     remove_column(:var_labels, :meaning_fr)
     remove_column(:var_labels, :description_fr)
  end
end