require 'net/imap'
require './item'

class Mail
  def initialize(folder, account)
    @host = 'imap.gmail.com'
    @port = 993
    @use_ssl = true
    @verify = false
    @certs = nil
    @folder = folder
    @search = 'UNSEEN'
    @user = account[:user_name]
    @password = account[:password]
  end
  

  def fetch
    m = Net::IMAP.new(@host, @port, @use_ssl, @certs, @verify)
    m.login(@user, @password)
    m.examine(@folder)

    m.search([@search]).each do |message_id|
      envelope = m.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      body = m.fetch(message_id, "RFC822")[0].attr["RFC822"]
      date = DateTime.parse(envelope.date).strftime("%m-%d-%Y")
      address = envelope.from[0]
      from = address.name || address.host
        
      Item.add_message 'new',
          :from => from,
          :to => envelope.to.to_s,
          :subject => envelope.subject.to_s,
          :cc => nil, #these are collections..
          :bc => nil, 
          :sent => date,
          :body => body,
          :headers => nil,
          :created_on => nil,
          :updated_on => nil
    end
    m.close
    m.logout
  end
  
end


# http://tools.ietf.org/html/rfc3501#section-6.4.4
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html


