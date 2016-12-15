require "notifiable/sender/version"
require 'httparty'

module Notifiable
  module Sender
    class V1
      include HTTParty
      debug_output $stdout
      
      def initialize(base_uri, access_id)
        @base_uri, @access_id = base_uri, access_id
      end
      
      def send_notification_to_user(user_alias, message: nil, parameters: nil, content_available: nil)
        filters = [{property: "user_alias", predicate: "eq", value: user_alias}]
        send_notification(message: message, parameters: parameters, content_available: content_available, filters: filters)
      end
      
      def send_notification(message: nil, parameters: nil, filters: nil, content_available: nil)
        body = {}
        body[:message] = message unless message.nil?
        body[:parameters] = parameters.to_json unless parameters.nil?
        body[:filters] = filters.to_json unless filters.nil?
        body[:content_available] = content_available unless content_available.nil?
        self.class.post("#{@base_uri}/api/v1/notifications", 
          body: { notification: body },
          headers: {"Authorization" => @access_id}
        )
      end
      
    end
  end
end
