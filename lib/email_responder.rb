class EmailResponder
  def initialize
    puts "new email responder"
  end
  
  def receive(msg_contents)
    begin 
      mail = TMail::Mail.parse(msg_contents)
      puts "subject: #{mail.subject}"
      puts "from: #{mail.from}"
      puts "body: #{mail.body.to_s}"
      
    rescue
      puts "problem parsing mail message"
    end
  end
end