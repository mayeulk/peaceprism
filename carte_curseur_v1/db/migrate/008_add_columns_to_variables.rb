class AddColumnsToVariables < ActiveRecord::Migration
  def self.up
    add_column(:variables, :long_name, :string)
    add_column(:variables, :code_var, :string)
    add_column(:variables, :descr_before, :text)
    add_column(:variables, :descr_after, :text)
    add_column(:variables, :long_name_fr, :string) 
    add_column(:variables, :descr_before_fr, :text)
    add_column(:variables, :descr_after_fr, :text)
    add_column(:variables, :page, :integer)
  end

  def self.down
    remove_column(:variables, :long_name) 
    remove_column(:variables, :code_var)
    remove_column(:variables, :descr_before)
    remove_column(:variables, :descr_after)
    remove_column(:variables, :long_name_fr) 
    remove_column(:variables, :descr_before_fr)
    remove_column(:variables, :descr_after_fr)
    remove_column(:variables, :page)
  end
end