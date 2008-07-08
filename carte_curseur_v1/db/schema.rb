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

ActiveRecord::Schema.define(:version => 6) do

  create_table "annees", :id => false, :force => true do |t|
    t.integer "annee"
  end

  add_index "annees", ["annee"], :name => "annee_idx", :unique => true

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
    t.string  "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.decimal "var10"
    t.decimal "var11"
  end

  create_table "dataset_10", :force => true do |t|
    t.integer "var1"
    t.decimal "var2"
    t.decimal "var3"
    t.decimal "var4"
    t.integer "var5"
  end

  create_table "dataset_11", :force => true do |t|
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

  create_table "dataset_12", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.integer "var10"
    t.integer "var11"
    t.integer "var12"
    t.integer "var13"
    t.integer "var14"
    t.integer "var15"
    t.integer "var16"
    t.integer "var17"
    t.integer "var18"
    t.integer "var19"
    t.decimal "var20"
  end

  create_table "dataset_13", :force => true do |t|
    t.string  "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.decimal "var10"
    t.decimal "var11"
  end

  create_table "dataset_14", :force => true do |t|
    t.integer "var1"
    t.string  "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.decimal "var7"
  end

  create_table "dataset_15", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.string  "var3"
    t.integer "var4"
    t.string  "var5"
    t.integer "var6"
    t.integer "var7"
    t.decimal "var8"
  end

  create_table "dataset_16", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.decimal "var7"
  end

  create_table "dataset_17", :force => true do |t|
    t.string  "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
  end

  create_table "dataset_18", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.string  "var3"
    t.string  "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.integer "var10"
    t.integer "var11"
    t.integer "var12"
    t.integer "var13"
    t.integer "var14"
    t.integer "var15"
    t.integer "var16"
    t.integer "var17"
    t.integer "var18"
    t.integer "var19"
    t.integer "var20"
    t.integer "var21"
    t.integer "var22"
    t.integer "var23"
    t.integer "var24"
    t.integer "var25"
    t.integer "var26"
    t.integer "var27"
    t.integer "var28"
    t.integer "var29"
    t.integer "var30"
    t.integer "var31"
    t.integer "var32"
    t.integer "var33"
    t.integer "var34"
    t.integer "var35"
    t.integer "var36"
    t.decimal "var37"
  end

  create_table "dataset_19", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
    t.decimal "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
  end

  create_table "dataset_2", :force => true do |t|
    t.integer "var1"
    t.string  "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.decimal "var7"
  end

  create_table "dataset_20", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
    t.decimal "var5"
  end

  create_table "dataset_21", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.decimal "var3"
    t.decimal "var4"
  end

  create_table "dataset_22", :force => true do |t|
    t.integer "var1"
    t.decimal "var2"
    t.decimal "var3"
    t.decimal "var4"
    t.integer "var5"
  end

  create_table "dataset_23", :force => true do |t|
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

  create_table "dataset_24", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.integer "var10"
    t.integer "var11"
    t.integer "var12"
    t.integer "var13"
    t.integer "var14"
    t.integer "var15"
    t.integer "var16"
    t.integer "var17"
    t.integer "var18"
    t.integer "var19"
    t.decimal "var20"
  end

  create_table "dataset_3", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.string  "var3"
    t.integer "var4"
    t.string  "var5"
    t.integer "var6"
    t.integer "var7"
    t.decimal "var8"
  end

  create_table "dataset_4", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.integer "var4"
    t.integer "var5"
    t.integer "var6"
    t.decimal "var7"
  end

  create_table "dataset_5", :force => true do |t|
    t.string  "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
  end

  create_table "dataset_6", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.string  "var3"
    t.string  "var4"
    t.integer "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
    t.integer "var9"
    t.integer "var10"
    t.integer "var11"
    t.integer "var12"
    t.integer "var13"
    t.integer "var14"
    t.integer "var15"
    t.integer "var16"
    t.integer "var17"
    t.integer "var18"
    t.integer "var19"
    t.integer "var20"
    t.integer "var21"
    t.integer "var22"
    t.integer "var23"
    t.integer "var24"
    t.integer "var25"
    t.integer "var26"
    t.integer "var27"
    t.integer "var28"
    t.integer "var29"
    t.integer "var30"
    t.integer "var31"
    t.integer "var32"
    t.integer "var33"
    t.integer "var34"
    t.integer "var35"
    t.integer "var36"
    t.decimal "var37"
  end

  add_index "dataset_6", ["var2"], :name => "dataset_6_var2_idx"
  add_index "dataset_6", ["var5"], :name => "dataset_6_var5_idx"

  create_table "dataset_7", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
    t.decimal "var5"
    t.integer "var6"
    t.integer "var7"
    t.integer "var8"
  end

  create_table "dataset_8", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.integer "var3"
    t.decimal "var4"
    t.decimal "var5"
  end

  create_table "dataset_9", :force => true do |t|
    t.integer "var1"
    t.integer "var2"
    t.decimal "var3"
    t.decimal "var4"
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

  create_table "diese_null", :id => false, :force => true do |t|
    t.integer "annee"
    t.integer "begin"
    t.integer "end"
    t.text    "ccode"
    t.string  "fips_cntry", :limit => 2
    t.integer "diese"
    t.integer "manquante"
  end

  create_table "fips_cow_codes", :force => true do |t|
    t.string   "country_name"
    t.integer  "cowcode"
    t.string   "fips_cntry"
    t.integer  "contcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fips_cow_codes", ["fips_cntry"], :name => "fipscowcodes_fips_cntry_idx"

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

  create_table "tablepaysannees", :id => false, :force => true do |t|
    t.text    "ccode"
    t.integer "annee"
  end

  add_index "tablepaysannees", ["ccode"], :name => "ccode_paysannees_idx"
  add_index "tablepaysannees", ["ccode", "annee"], :name => "table_paysannees_idx"

  create_table "tabletab", :id => false, :force => true do |t|
    t.integer "annee"
    t.text    "ccode"
    t.integer "begin"
    t.integer "end"
  end

  add_index "tabletab", ["ccode"], :name => "tabletab_ccode_idx"

# Could not dump table "test" because of following StandardError
#   Unknown type 'geometry' for column 'geom'

  create_table "tmp", :id => false, :force => true do |t|
    t.text "?column?"
  end

  create_table "variable_qual", :force => true do |t|
    t.integer "var_key"
    t.integer "var_id"
    t.integer "dataset_id"
    t.integer "valeur"
    t.text    "signification"
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
    t.float    "mini"
    t.float    "maxi"
    t.integer  "binary_var"
    t.integer  "qualitatif_ordonne"
  end

# Could not dump table "world" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "world2" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "world_incomplet" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

end
