require 'rubygems'
require 'sinatra'
require './mail'
require './item'
require './blow_fish'

enable :logging

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
  @item_queues = Item.get_queues
  haml :view
end

post '/item/:id' do
  id = params[:id]
  queue = params[:item_queue]
  Item.move_to_queue!(id, queue)
  redirect '/'
end


get '/mail' do
  mail = Mail.new 'INBOX',
              :user_name => 'cgabaldon@gmail.com',
              :password =>  Blowfish.decrypt("key","\xDB\x1E`.\x82\xA9\xDC3\xBC,5\xE4\xB0\x82\xB7\xE9")
              
  mail.fetch
  redirect '/'
end

