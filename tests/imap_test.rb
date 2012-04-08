
# http://tools.ietf.org/html/rfc3501#section-6.4.4
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html

require 'net/imap'
require 'date'

search_command = 'UNSEEN'
host = 'imap.gmail.com'
port = 993
use_ssl = true
verify_ssl = false

mail = Net::IMAP.new(host, port, use_ssl, nil, verify_ssl)
mail.login('cgabaldon@gmail.com', '')
mail.examine('INBOX')

mail.search([search_command]).each do |message_id|
  envelope = mail.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
  date = DateTime.parse(envelope.date).strftime("%m-%d-%Y")
  address = envelope.from[0]
  from = address.name || address.host
  puts "#{date} \t #{from}: \t#{envelope.subject}"
  puts "CC:"
  envelope.cc.each { |cc| puts cc } unless envelope.cc.nil? 
  puts "BC:"
  envelope.bcc.each { |bc| puts bc } unless envelope.bcc.nil?
  #puts  mail.fetch(message_id, "RFC822")[0].attr["RFC822"]
end

mail.close
mail.logout
mail.disconnect