class CreateConflitsExts < ActiveRecord::Migration
  def self.up
    create_table :conflits_ext do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :conflits_ext
  end
end
