
# http://tools.ietf.org/html/rfc3501#section-6.4.4
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html

require 'net/imap'
require 'models'

class Mail
  def initialize(folder, account)
    @host = 'imap.gmail.com'
    @port = 993
    @use_ssl = true
    @folder = folder
    @search = 'UNSEEN'
    @user = account[:user_name]
    @password = account[:password]
  end
  
  def fetch
    m = Net::IMAP.new(@host, @port, @use_ssl)
    m.login(@user, @password)
    m.examine(@folder)

    m.search([@search]).each do |message_id|
      envelope = m.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      
      Item.add_message 'new',
          :from => envelope.from[0].name.to_s,
          :to => envelope.to.to_s,
          :subject => envelope.subject.to_s,
          :cc => nil, #this are collections..
          :bc => nil, 
          :sent => Date.today.strftime("%m-%d-%Y"),
          :body => 'Body..',#envelope.body, #todo figure out how to dig out the body..
          :headers => nil,
          :created_on => nil,
          :updated_on => nil
    end
    m.close
  end
  
end



