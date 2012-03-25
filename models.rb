require 'date'
require 'rubygems'
require 'sequel'


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
    
  end
end

