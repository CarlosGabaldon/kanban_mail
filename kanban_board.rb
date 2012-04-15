require 'rubygems'
require 'sinatra'
require 'pathname'
require './item'
require './partials'

configure do
  enable :sessions
  enable :logging
end

helpers Sinatra::Partials

## HOME ##
get '/' do
  redirect '/login' unless logged_in?
    
  @new_items = Item.get_all_new || []
  @action_items = Item.get_all_action || []
  @hold_items = Item.get_all_hold || []
  @completed_items = Item.get_all_completed || []
  haml :list
end


## ITEM ROUTES ##
get '/item/:id' do
  redirect '/login' unless logged_in?
    
  @item = Item.get(params[:id])
  @path = request.path_info
  @item_queues = Item.get_queues
  haml :view
end

post '/item/:id' do
  id = params[:id]
  days_due = params[:days_due]
  queue = params[:item_queue]
  Item.move_to_queue!(id, queue, days_due.to_i)
  redirect '/'
end

## AUTHENTCATION ROUTES ##
get '/login' do
  haml :login, :layout => :public_layout
end

post '/login' do
  user = params[:email]
  pwd = params[:password]
  if user == 'cgabaldon@gmail.com' and pwd == "FUCKYOU2"
    session[:logged_in] = true
  end
  redirect '/'
end

get '/logout' do
  session.clear
  redirect '/'
end


## MAIL ROUTES ##
get '/mail' do
  
  Item.load_queue! "new",
    :user_name => 'cgabaldon@gmail.com',
    :password => Password.decrypt("key","\xDB\x1E`.\x82\xA9\xDC3\xBC,5\xE4\xB0\x82\xB7\xE9"),
    :address => "imap.gmail.com"

  redirect '/'
end

## ERROR ROUTES ##
not_found do
  haml :not_found, :layout => :public_layout
end

error do
  haml :error, :layout => :public_layout
end

private
def logged_in?
  if session[:logged_in].nil?
    false
  else
    true
  end
end
