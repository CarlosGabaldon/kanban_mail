require 'rubygems'
require 'sinatra'
require 'sequel'
require 'imap'

enable :logging

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

get '/item/:id' do
  @item = Item.get(params[:id])
  @path = request.path_info
  @item_states = ['new', 'action', 'hold', 'completed']
  logger.info("GET '/item/#{params[:id]}' @item.subject => #{@item.subject}")
  haml :view
end

post '/item/:id' do
  #@item = Item.update(:state => )
end


get '/mail' do
  mail = Mail.new 'INBOX',
              :user_name => 'cgabaldon@gmail.com',
              :password =>  ''
              
  mail.fetch
  redirect '/'
end

