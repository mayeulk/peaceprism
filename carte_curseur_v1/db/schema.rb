# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

# Could not dump table "buf" because of following StandardError
#   Unknown type 'geometry' for column 'buffer'

# Could not dump table "conflits_ext" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "conflits_ext_copy" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "conflitsexts", :force => true do |t|
    t.text    "ltlgrd"
    t.integer "begin"
    t.integer "finish"
    t.integer "intensity"
    t.integer "type_of_war"
    t.string  "territory",   :limit => nil
    t.string  "side_a",      :limit => 128
    t.string  "side_b",      :limit => 128
  end

  create_table "dataset_1", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.decimal "var3"
    t.decimal "var4"
  end

  create_table "dataset_2", :force => true do |t|
    t.integer "var1"
    t.decimal "var2"
    t.decimal "var3"
    t.decimal "var4"
    t.integer "var5"
  end

  create_table "dataset_3", :force => true do |t|
    t.integer "var1"
    t.decimal "var2"
    t.decimal "var3"
    t.decimal "var4"
    t.decimal "var5"
    t.decimal "var6"
    t.decimal "var7"
    t.decimal "var8"
    t.decimal "var9"
    t.decimal "var10"
    t.decimal "var11"
    t.decimal "var12"
    t.decimal "var13"
    t.decimal "var14"
    t.decimal "var15"
    t.decimal "var16"
    t.decimal "var17"
    t.decimal "var18"
    t.decimal "var19"
    t.decimal "var20"
    t.decimal "var21"
    t.decimal "var22"
    t.decimal "var23"
    t.decimal "var24"
    t.decimal "var25"
  end

  create_table "datasets", :force => true do |t|
    t.string   "configuration_file"
    t.string   "data_file_name"
    t.string   "data_set_full_name"
    t.string   "data_set_short_name"
    t.text     "data_set_citation"
    t.string   "unit_of_analysis"
    t.integer  "first_year_possible"
    t.integer  "last_year_possible"
    t.boolean  "label_line_in_data_file"
    t.integer  "number_of_variables"
    t.integer  "number_of_cases"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identifierccode1_var"
    t.integer  "identifierccode2_var"
    t.integer  "identifieryear_var"
  end

  create_table "fips_cow_codes", :force => true do |t|
    t.string   "country_name"
    t.integer  "cowcode"
    t.string   "fips_cntry"
    t.integer  "contcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
  end

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

# Could not dump table "test" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "tmp", :id => false, :force => true do |t|
    t.text "?column?"
  end

  create_table "variables", :force => true do |t|
    t.integer  "var_id"
    t.integer  "dataset_id"
    t.string   "name"
    t.string   "format"
    t.string   "kind"
    t.string   "reverse"
    t.string   "missing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "world" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "world2" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "world3" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

end
