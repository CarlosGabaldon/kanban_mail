require 'rubygems'
require 'sequel'
require 'date'
require './blow_fish'

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
  text :sent
  text :body
  text :headers
  timestamp :due
  timestamp :created_on
  timestamp :updated_on
end


DB[:items].insert(
  :queue => 'new',
  :from => 'Mint.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Your tax refund has arrived.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :due => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :queue => 'new',
  :from => 'Amazon.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'You books have shipped',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :due => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :queue => 'action',
  :from => 'Dice.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'New jobs for your review.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :due => nil,
  :created_on => nil,
  :updated_on => nil)

DB[:items].insert(
  :queue => 'hold',
  :from => 'Monster.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Interview tips.',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :due => nil,
  :created_on => nil,
  :updated_on => nil)
  
DB[:items].insert(
  :queue => 'completed',
  :from => 'Mint.com',
  :to => 'cgabaldon@gmail.com',
  :subject => 'Large deposit',
  :cc => nil,
  :bc => nil,
  :sent => Date.today.strftime("%m-%d-%Y"),
  :body => 'Body..',
  :headers => nil,
  :due => nil,
  :created_on => nil,
  :updated_on => nil)