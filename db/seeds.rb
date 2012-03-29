require 'rubygems'
require 'sequel'
require 'date'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://kanbanmail_app:kanban@localhost/kanbanmail') 

unless DB.table_exists? :items
  DB.create_table :items do
    primary_key :id
    text :state
    text :from
    text :to
    text :subject
    text :cc
    text :bc
    text :sent
    text :body
    text :headers
    timestamp :created_on
    timestamp :updated_on
  end
end

# populate the table
DB[:items].insert(
  :state => 'new',
  :from => 'Mint.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Your tax refund has arrived.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :state => 'new',
  :from => 'Amazon.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'You books have shipped',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :state => 'action',
  :from => 'Dice.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'New jobs for your review.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :state => 'hold',
  :from => 'Monster.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Interview tips.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :created_on => nil,
  :updated_on => nil)
  
DB[:items].insert(
  :state => 'completed',
  :from => 'Mint.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Large deposit',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :created_on => nil,
  :updated_on => nil)