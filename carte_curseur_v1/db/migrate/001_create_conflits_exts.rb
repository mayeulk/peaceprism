class CreateConflitsExts < ActiveRecord::Migration
  def self.up
    #create_table :conflits_ext do |t|
      # t.column :name, :string
#    end
  end

  def self.down
    # Ligne commentee pour éviter "rake db:migrate VERSION=zero" du fait d'une faute de frappe.
    # Decommenter la ligne suivante pour migrer vers la version 0
    # drop_table :conflits_ext
  end
end
