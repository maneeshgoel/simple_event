class ReceiveTextController < ApplicationController
  def index
     
    # let's pretend that we've mapped this action to 
      # http://localhost:3000/sms in the routes.rb file

    message_body = params["Body"]
    from_number = params["From"]

    puts "from: #{from_number}, message: #{message_body}"
    parsed_message = message_body.split(" ")
    @event = Event.find(parsed_message[0].to_i)
    from = from_number[2..from_number.length]
    @user = User.find_by_phone(from)
    response = parsed_message[1]
    if response == "y" || response == "Y"
      @attendee = Attendee.find_by_user_id_and_event_id(@user.id, @event.id)
      if @attendee == nil
        @attendee = Attendee.new(:user_id => @user.id, :event_id => @event.id)
        @attendee.save
        send_text(@user, @event, "y")
      end 
    elsif response == "n" || response == "N"
      @attendee = Attendee.find_by_user_id_and_event_id(@user.id, @event.id)
      if @attendee
        @attendee.destroy
        send_text(@user, @event, "n")
      end
    else
      send_text(@user, @event, "b")
    end
  end
  
  def send_text(user, event, disp)
    @client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])
    @account = @client.account
    if disp == "b"
      @message = "bad response; event: #{event.name}. Please reply \"#{event.id} y\" OR \"#{event.id} Y\" to accept, \"#{event.id} n\" OR \"#{event.id} N\" to decline"
    else
      @message = "#{disp == "y" ? "Accepted" : "Declined"} Event: #{event.name}, D: #{ l event.datetime, :format => :long}, L: #{event.location}"
    end
    @account.sms.messages.create({:from => '+16503533465', :to => "+1#{user.phone}", :body => @message})
  end
end
