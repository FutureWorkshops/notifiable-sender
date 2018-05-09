require 'rest-client'
require 'api-auth'
require 'json'
require 'logger'

module Notifiable
  class Sender    
    def initialize(access_id, base_uri: 'https://notifiable.futureworkshops.com', secret_key: nil, logger: Logger.new(STDOUT))
      raise 'base_uri cannot be nil' if !base_uri || base_uri.empty?
      raise 'access_id cannot be nil' if !access_id || access_id.empty? 
      
      @base_uri, @access_id, @secret_key, @logger = base_uri, access_id, secret_key, logger
    end
    
    def send_notification_to_users(user_aliases, title: nil, message: nil, parameters: nil, content_available: nil)
      raise 'user_aliases should be Enumerable' unless user_aliases.is_a? Enumerable
      
      user_aliases.each {|user_alias| send_notification_to_user(user_alias, title, message, parameters, content_avaiable)}
    end
    
    def send_notification_to_user(user_alias, title: nil, message: nil, parameters: nil, content_available: nil)
      filters = [{property: "user_alias", predicate: "eq", value: user_alias}]
      send_notification(title: title, message: message, parameters: parameters, content_available: content_available, filters: filters)
    end
    
    # 
    # Params:
    # - filters: An array of hashes to filter notifications, e.g. [{property: "alert_level", predicate: "lt", value: 3}]
    def send_notification(title: nil, message: nil, parameters: nil, filters: nil, content_available: nil)
      body = {}
      body[:title] = title unless title.nil?
      body[:message] = message unless message.nil?
      body[:parameters] = parameters.to_json unless parameters.nil?
      body[:filters] = filters.to_json unless filters.nil?
      body[:content_available] = content_available unless content_available.nil?
      headers = {}
      headers[:authorization] = @access_id unless @secret_key
      @request = RestClient::Request.new url: "#{@base_uri}/api/v1/notifications", payload: {notification: body}, method: :post, headers: headers
      @request = ApiAuth.sign!(@request, @access_id, @secret_key) if @secret_key
      begin
        @request.execute
      rescue RestClient::ExceptionWithResponse => e
        @logger.warn "Request failed with code: #{e.response.code} body: #{e.response.body}"
      end
    end
  end
end
