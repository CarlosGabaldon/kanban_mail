require 'rubygems'
require 'sinatra'
require 'sequel'
require 'imap'

configure do
	DB = Sequel.sqlite('./db/kanban_mail.db')
end

require 'models'

get '/' do

  @new_items = Item.get_all_new || []
  @action_items = Item.get_all_action || []
  @hold_items = Item.get_all_hold || []
  @completed_items = Item.get_all_completed || []
  
  haml :list
end


get '/mail' do
  mail = Mail.new 'INBOX',
              :user_name => 'cgabaldon@gmail.com',
              :password =>  ''
              
  mail.fetch
  redirect '/'
end

