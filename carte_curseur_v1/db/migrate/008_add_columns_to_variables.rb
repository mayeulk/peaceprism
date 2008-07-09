class AddColumnsToVariables < ActiveRecord::Migration
  def self.up
    # Pour mettre à jour les vues:
    # ./script/generate scaffold Variable var_id:integer dataset_id:integer name:string  format:string  kind:string reverse:string missing:string   created_at:datetime  updated_at:datetime  mini:float  maxi:float   binary_var:integer qualitatif_ordonne:integer  long_name:string  code_var:string   descr_before:text    descr_after:text    long_name_fr:string   descr_before_fr:text   descr_after_fr:text page:integer
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