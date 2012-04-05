require 'date'
require 'rubygems'
require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://kanbanmail_app:kanban@localhost/kanbanmail') 

class Item < Sequel::Model

  class << self

    def get_all_new
      Item.filter(:queue => 'new').order_by(:sent.desc)
    end
    
    def get_all_action
      Item.filter(:queue => 'action').order_by(:due.asc)
    end
    
    def get_all_hold
      Item.filter(:queue => 'hold').order_by(:due.desc)
    end
    
    def get_all_completed
      Item.filter(:queue => 'completed').order_by(:sent.desc) 
    end
    
    def get(id)
      Item[:id => id]
    end
    
    def get_queues
      ['new', 'action', 'hold', 'completed']
    end
    
    def move_to_queue!(id, queue, days_due = 0)
      due = nil
      due = (Date.today + days_due) unless days_due == 0
      Item.filter(:id => id).update(:queue => queue, :due => due)
    end
    
    def add_message(queue, message)
      
      DB[:items].insert(
        :queue => queue,
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

