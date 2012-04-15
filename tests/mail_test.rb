require 'mail'

imap_address = "imap.gmail.com"
account_user = 'cgabaldon@gmail.com'
account_pwd = ''


Mail.defaults do
  retriever_method :imap, 
                   :address    => imap_address,
                   :port       => 993,
                   :user_name  => account_user,
                   :password   => account_pwd,
                   :enable_ssl => true
end

recent_mail = Mail.find(:what => :last, :keys => ["ALL", "UNSEEN"], :ready_only => true, :count => 9999, :order => :desc)

puts "Found #{recent_mail.length} emails."

recent_mail.each do |mail|
  date = mail.date.strftime("%m-%d-%Y %I:%M:%S %p %Z")
  from = (mail.from || []).join(',')
  to = (mail.to || []).join(',') 
  cc = (mail.cc || []).join(',')
  bcc = (mail.bcc || []).join(',')
  subject = mail.subject
  body = mail.body
  
  puts "#{from} #{subject} - #{date}"
  puts "Cc: #{cc}"
  puts "Bcc: #{bcc}"
  #puts body
end