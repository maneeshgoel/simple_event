require 'rubygems'
require 'twilio-ruby'

@account_sid = 'AC06aacee58671a9bad8b9577073712838'
@auth_token = 'ba70dc52090734b8b2d524dcb6ca167c'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new(@account_sid, @auth_token)


@account = @client.account
@message = "hi from test" 
@account.sms.messages.create({:from => '+14155992671', :to => '+16507992911', :body => @message})
