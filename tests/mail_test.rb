require 'mail'

pop_address = "pop.gmail.com"
account_user = 'cgabaldon@gmail.com'
account_pwd = 'Jazcat1228'


Mail.defaults do
  retriever_method :imap, 
                   :address    => pop_address,
                   :port       => 993,
                   :user_name  => account_user,
                   :password   => account_pwd,
                   :enable_ssl => true
end

recent_mail = Mail.find(:what => :last, :count => 5, :order => :desc)

puts "Found #{recent_mail.length} emails."

recent_mail.each do |mail|
  date = mail.date.strftime("%m-%d-%Y")
  subject = mail.subject
  body = mail.body
  puts "#{subject} - #{date}"
  puts body
end