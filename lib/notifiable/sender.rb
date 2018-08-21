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
    
    def send_media_notification_to_users(user_aliases, media_url, title: nil, message: nil, parameters: {}, content_available: nil, thread_id: nil, category: nil, expiry: nil)
      raise 'user_aliases should be an array' unless user_aliases.is_a? Array
      raise 'media_url should not be blank' if media_url.nil? || media_url.empty?
      
      parameters = {media_url: media_url}.merge(parameters)
      filters = [{property: "user_alias", predicate: "in", value: user_aliases}]
      send_notification(title: title, message: message, parameters: parameters, content_available: content_available, filters: filters, thread_id: thread_id, mutable_content: true, category: category, expiry: expiry)
    end
          
    def send_notification_to_users(user_aliases, title: nil, message: nil, parameters: nil, content_available: nil, thread_id: nil, mutable_content: nil, category: nil, expiry: nil)
      raise 'user_aliases should be an array' unless user_aliases.is_a? Array
      
      filters = [{property: "user_alias", predicate: "in", value: user_aliases}]
      send_notification(title: title, message: message, parameters: parameters, content_available: content_available, filters: filters, thread_id: thread_id, mutable_content: mutable_content, category: category, expiry: expiry)
    end
    
    # 
    # Params:
    # - filters: An array of hashes to filter notifications, e.g. [{property: "alert_level", predicate: "lt", value: 3}]
    # - expiry: The system will not retry delivery past this date.
    def send_notification(title: nil, message: nil, parameters: nil, filters: nil, content_available: nil, thread_id: nil, mutable_content: nil, category: nil, expiry: nil)
      body = {}
      body[:title] = title unless title.nil?
      body[:message] = message unless message.nil?
      body[:parameters] = parameters.to_json unless parameters.nil?
      body[:filters] = filters.to_json unless filters.nil?
      body[:content_available] = content_available unless content_available.nil?
      body[:thread_id] = thread_id unless thread_id.nil?
      body[:mutable_content] = mutable_content unless mutable_content.nil?
      body[:category] = category unless category.nil?
      body[:expiry] = expiry unless expiry.nil?
      
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
