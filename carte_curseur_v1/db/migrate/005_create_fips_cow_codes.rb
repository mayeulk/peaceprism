class CreateFipsCowCodes < ActiveRecord::Migration
  def self.up
    create_table :fips_cow_codes do |t|
      t.string  :country_name
      t.integer :cowcode
      t.string  :fips_cntry
      t.timestamps
    end

  end

  def self.down
    drop_table :fips_cow_codes
  end
end
