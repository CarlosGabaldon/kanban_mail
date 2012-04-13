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
  
  def due_in_days
    unless self.due.nil?
      due_date = Date.parse(due.strftime("%Y-%m-%d"))
      due = due_date.mjd - Date.today.mjd # Use Modified Julian Day Number
      
      if due > 1
        "Due in #{due} days."
      elsif due == 1
        "Due in #{due} day."
      elsif due == 0
        "Due today!"
      elsif due == -1
        "Overdue by #{due/-1} day!"
      else due < 0
        "Overdue by #{due/-1} days!"
      end
      
    else
      ""
    end
  end
  
end

