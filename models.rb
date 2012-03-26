require 'date'
require 'rubygems'
require 'sequel'

DB = Sequel.sqlite('./db/kanban_mail.db')

class Item < Sequel::Model

  class << self

    def get_all_new
      Item.filter(:state => 'new')
    end
    
    def get_all_action
      Item.filter(:state => 'action')
    end
    
    def get_all_hold
      Item.filter(:state => 'hold')
    end
    
    def get_all_completed
      Item.filter(:state => 'completed')
      
    end
    
    def get(id)
      Item[:id => id]
    end
    
    def add_message(state, message)
      
      DB[:items].insert(
        :state => state,
        :from => message[:from],
        :to => message[:to],
        :subject => message[:subject],
        :cc => message[:cc],
        :bc => message[:bc],
        :sent => message[:sent],
        :body => message[:body],
        :headers => message[:headers],
        :created_on => nil,
        :updated_on => nil)
    end
    
  end
end

