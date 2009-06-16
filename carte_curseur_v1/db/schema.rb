# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

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

  create_table "var_labels", :force => true do |t|
    t.integer  "var_key"
    t.integer  "var_id"
    t.integer  "dataset_id"
    t.integer  "value"
    t.string   "meaning"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "long_name"
    t.string   "code_var"
    t.text     "descr_before"
    t.text     "descr_after"
    t.string   "long_name_fr"
    t.text     "descr_before_fr"
    t.text     "descr_after_fr"
    t.integer  "page"
  end

  add_index "variables", ["dataset_id", "var_id"], :name => "index_variables_on_var_id_and_dataset_id", :unique => true

end
