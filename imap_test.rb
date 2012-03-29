
# http://tools.ietf.org/html/rfc3501#section-6.4.4
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html

require 'net/imap'
require 'date'

@@search_command = 'UNSEEN'

mail = Net::IMAP.new('imap.gmail.com', 993, true)
mail.login('cgabaldon@gmail.com', 'Jazcat1228')
mail.examine('INBOX')

mail.search([@@search_command]).each do |message_id|
  envelope = mail.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
  date = DateTime.parse(envelope.date).strftime("%m-%d-%Y")
  puts "#{date} \t #{envelope.from[0].name}: \t#{envelope.subject}"
  puts "CC:"
  envelope.cc.each { |cc| puts cc } unless envelope.cc.nil? 
  puts "BC:"
  envelope.bcc.each { |bc| puts bc } unless envelope.bcc.nil?
  puts  mail.fetch(message_id, "RFC822")[0].attr["RFC822"]
end

mail.close
mail.logout
mail.disconnect