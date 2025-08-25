require 'sinatra'
require 'json'

class ChatbotTracker
  def initialize
    @conversations = {}
  end

  def track_conversation(user_id, message)
    if @conversations[user_id].nil?
      @conversations[user_id] = []
    end
    @conversations[user_id] << message
  end

  def get_conversation(user_id)
    @conversations[user_id]
  end
end

class RealtimeChatbotTracker < Sinatra::Base
  post '/track' do
    data = JSON.parse(request.body.read)
    user_id = data['user_id']
    message = data['message']
    chatbot_tracker.track_conversation(user_id, message)
    status 200
  end

  get '/conversation/:user_id' do
    user_id = params[:user_id]
    conversation = chatbot_tracker.get_conversation(user_id)
    conversation.nil? ? [].to_json : conversation.to_json
  end

  def chatbot_tracker
    @chatbot_tracker ||= ChatbotTracker.new
  end
end

RealtimeChatbotTracker.run!