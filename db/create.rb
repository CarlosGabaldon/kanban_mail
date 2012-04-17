require 'rubygems'
require 'sequel'
require 'date'


DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://kanbanmail_app:kanban@localhost/kanbanmail') 

DB.drop_table :items

DB.create_table :items do
  primary_key :id
  text :queue
  text :from
  text :to
  text :subject
  text :cc
  text :bc
  timestamp :sent
  text :body
  text :headers
  timestamp :due
  timestamp :created_on
  timestamp :updated_on
end