class EventsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :edit, :show]
  def new
    @event = Event.new()
  end
  
  def create
    @event = Event.new(params[:event])
    @event.save
    #text everyone here
    send_texts(@event, "n")
    redirect_to event_path(@event)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "event updated!"
      #text everyone here
      send_texts(@event, "u")
      redirect_to event_path(@event)
    else
      flash[:error] = "couldn't update event!"
      redirect_to event_path(@event)
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    @events = Event.all
  end
  
  def attending
    puts "attending called!"
    @event = Event.find(params[:id])
    puts "params[:attending] is #{params[:attending]}"
    if params[:attending].to_i > 0
      puts "there's something in params attending! it's #{params[:attending]}"
      @attendee = Attendee.find_by_user_id_and_event_id(current_user.id, @event.id)
      puts "attendee == #{@attendee}"
      if @attendee == nil
        puts "creating a new attendee record!"
        @attendee = Attendee.new(:user_id => current_user.id, :event_id => @event.id)
        @attendee.save
      end
    else
      puts "there's nothing in params attending!"
      @attendee = Attendee.find_by_user_id_and_event_id(current_user.id, @event.id)
      if @attendee
        puts "deleting attendee record!"
        @attendee.destroy
      end
    end
    redirect_to event_path(@event)
  end
  
  def send_texts(event, flag)
    @users = User.all
  
    @client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])
    @account = @client.account
    @message = "#{flag == "n" ? "New" : "Updated"} Event: #{event.name}, D: #{l event.datetime, :format => :long}, L: #{event.location}. Reply \"#{event.id}\" y to accept, \"#{event.id} n\" to decline"
    @users.each do |user|
      @account.sms.messages.create({:from => '+16503533465', :to => "+1#{user.phone}", :body => @message})
    end
  end
end
