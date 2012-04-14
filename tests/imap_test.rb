
# http://tools.ietf.org/html/rfc3501#section-6.4.4
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html
# http://ruby-doc.org/stdlib-1.9.3/libdoc/net/smtp/rdoc/Net/SMTP.html

require 'net/imap'
require 'net/smtp'
require 'date'

search_command = 'UNSEEN'
mail_domain = 'gmail.com'
imap_host = 'imap.gmail.com'
smtp_host = 'smtp.gmail.com'
account_user = 'cgabaldon@gmail.com'
account_pwd = 'Jazcat1228'
imap_port = 993
smtp_port = 587
use_ssl = true
verify_ssl = false

puts "#################GET EMAIL############################"

mail = Net::IMAP.new(imap_host, imap_port, use_ssl, nil, verify_ssl)
mail.login(account_user, account_pwd)
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


puts "#################SEND EMAIL############################"

message = <<END_OF_MESSAGE
From: Your Name <#{account_user}>
To: Destination Address <#{account_user}>
Subject: KanbanMail message
Date: Wed, 11 Apr 2012 16:26:43 +0900
Message-Id: <unique.message.id.string@example.com>

This is a test message.

END_OF_MESSAGE
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)  
smtp_session = Net::SMTP.start(smtp_host, smtp_port, mail_domain, account_user, account_pwd, :login )

smtp_session do |smtp|
  smtp.send_message message,
                    account_user,
                    account_user
end



