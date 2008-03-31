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

ActiveRecord::Schema.define(:version => 1) do

  create_table "dataset_researchers", :id => false, :force => true do |t|
    t.integer  "dataset_id"
    t.integer  "baseid_pb"
    t.integer  "researcher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasets", :force => true do |t|
    t.integer  "baseid_pb"
    t.string   "name"
    t.text     "description"
    t.text     "temporaldomain"
    t.text     "spatialdomain"
    t.text     "typeofevent"
    t.text     "definitionofevent"
    t.text     "violencethreshold"
    t.text     "datacoded"
    t.text     "principalresearcher"
    t.text     "accesstoinformation"
    t.text     "url"
    t.boolean  "recherche_commencee"
    t.boolean  "recherche_finie"
    t.string   "manque_info_importantes"
    t.string   "debut"
    t.string   "fin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "researchers", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "email"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
