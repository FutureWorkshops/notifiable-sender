require 'spec_helper'

describe Notifiable::Sender do
  
  let(:access_id) { "abc123" }
  let(:base_uri) { "http://notifiable.com" }
  let(:args) { {} }
  let(:notification_query_params) { args }
  subject { Notifiable::Sender.new(access_id, base_uri: base_uri) }
  
  describe "#send_notification" do
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(body: {notification: notification_query_params}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_notification(args)
    end    
    
    context "with message" do
      let(:args) { {message: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with parameters" do
      let(:args) { {parameters: {flow_id: 5}} }
      let(:notification_query_params) { {parameters: "{\"flow_id\":5}"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with filters" do
      let(:args) { {filters: [{"property": "lat", "predicate": "lt", "value": 40.3}]} } 
      let(:notification_query_params) { {filters: "[{\"property\":\"lat\",\"predicate\":\"lt\",\"value\":40.3}]"} }     
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with content_available" do
      let(:args) { {content_available: true} } 
      let(:notification_query_params) { {content_available: "true"} }     
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with thread_id" do
      let(:args) { {thread_id: 'threadidabc123'} } 
      let(:notification_query_params) { {thread_id: 'threadidabc123'} }     
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with mutable_content" do
      let(:args) { {mutable_content: true} } 
      let(:notification_query_params) { {mutable_content: "true"} }     
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with category" do
      let(:args) { {category: 'MESSAGE'} } 
      let(:notification_query_params) { {category: "MESSAGE"} }     
      it { expect(@response.code).to eq 200 }      
    end
  end
  
  describe '#send_notification_to_users' do
    let(:user_aliases) { ['matt@futureworkshops.com', 'davide@futureworkshops.com'] } 
    let(:notification_query_params) {  additional_notification_query_params.merge({filters: "[{\"property\":\"user_alias\",\"predicate\":\"in\",\"value\":#{user_aliases.to_json}}]"}) }
    let(:additional_notification_query_params) { args }
    let(:args) { {} }
    
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(body: {notification: notification_query_params}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_notification_to_users(user_aliases, args)
    end 
           
    context "title" do
      let(:args) { {title: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "message" do
      let(:args) { {message: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "mutable content" do
      let(:args) { {mutable_content: true} } 
      let(:additional_notification_query_params) { {mutable_content: "true"} }   
      it { expect(@response.code).to eq 200 }      
    end
    
    context "category" do
      let(:args) { {category: 'MESSAGE'} } 
      let(:additional_notification_query_params) { {category: 'MESSAGE'} }   
      it { expect(@response.code).to eq 200 }      
    end
    
    context "parameters" do
      let(:args) { {parameters: {flow_id: 5}} }
      let(:additional_notification_query_params) { {parameters: "{\"flow_id\":5}"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "content available" do
      let(:args) { {content_available: true} }
      let(:additional_notification_query_params) { {content_available: "true"} }   
      it { expect(@response.code).to eq 200 }      
    end
    
    context "expiry" do
      let(:time) { Time.now + (60 * 60) }
      let(:args) { {expiry: time} }
      let(:additional_notification_query_params) { {expiry: time.to_s} }   
      it { expect(@response.code).to eq 200 }      
    end
  end
  
  describe '#send_media_notification_to_users' do
    let(:user_aliases) { ['matt@futureworkshops.com', 'davide@futureworkshops.com'] }
    let(:media_url) { 'http://example.com/image-1.png'} 
    let(:notification_query_params) {  additional_notification_query_params.merge({filters: "[{\"property\":\"user_alias\",\"predicate\":\"in\",\"value\":#{user_aliases.to_json}}]", parameters: notification_parameters.to_json, mutable_content: "true"}) }
    let(:notification_parameters) { {media_url: media_url} }
    let(:additional_notification_query_params) { args }
    let(:args) { {} }
    
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(body: {notification: notification_query_params}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_media_notification_to_users(user_aliases, media_url, args)
    end 
           
    context "title" do
      let(:args) { {title: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "category" do
      let(:args) { {category: 'MESSAGE'} } 
      let(:additional_notification_query_params) { {category: 'MESSAGE'} }   
      it { expect(@response.code).to eq 200 }      
    end
  end
end
