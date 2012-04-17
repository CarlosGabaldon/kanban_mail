require 'date'
require 'rubygems'
require 'sequel'
require 'mail'
require 'openssl'

module Password
   def self.cipher(mode, key, data)
     cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').send(mode)
     cipher.key = Digest::SHA256.digest(key)
     cipher.update(data) << cipher.final
   end

   def self.encrypt(key, data)
     cipher(:encrypt, key, data)
   end

   def self.decrypt(key, text)
     cipher(:decrypt, key, text)
   end
end


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
    
    
    def load_queue!(queue, account)
      
      Mail.defaults do
        retriever_method :imap, 
                         :address    => account[:address],
                         :port       => 993,
                         :user_name  => account[:user_name],
                         :password   => account[:password],
                         :enable_ssl => true
      end

      recent_mail = Mail.find :what       => :last, 
                              :keys       => ["ALL", "UNSEEN"], 
                              :ready_only => true, 
                              :count      => 9999, 
                              :order      => :desc

      recent_mail.each do |mail|
        
        date = mail.date #.strftime("%m-%d-%Y %I:%M:%S %p %Z")
        from = (mail.from || []).join(',')
        to = (mail.to || []).join(',') 
        cc = (mail.cc || []).join(',')
        bcc = (mail.bcc || []).join(',')
        subject = mail.subject.to_s
        body = mail.body.to_s
        
        
        DB[:items].insert(
          :queue => queue,
          :from => from,
          :to => to,
          :subject => subject,
          :cc => cc,
          :bc => bcc,
          :sent => date,
          :body => body,
          :headers => nil,
          :created_on => nil,
          :updated_on => nil)
        
      end
      
    end
    
  end
  
  def sent_friendly
    self.sent.strftime("Sent on %m-%d-%Y at %I:%M:%S %p")
  end
  
  def from_friendly
    "From #{self.from}"
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

