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
  end
  
  describe "#send_notification_to_user" do
    let(:user_alias) { "matt@futureworkshops.com" }
    let(:args) { {} }
    let(:notification_query_params) { additional_notification_query_params.merge({filters: "[{\"property\":\"user_alias\",\"predicate\":\"eq\",\"value\":\"#{user_alias}\"}]"}) }
    let(:additional_notification_query_params) { args }
    
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(body: {notification: notification_query_params}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_notification_to_user(user_alias, args)
    end 
    
    context "with message" do
      let(:args) { {message: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with parameters" do
      let(:args) { {parameters: {flow_id: 5}} }
      let(:additional_notification_query_params) { {parameters: "{\"flow_id\":5}"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with content available" do
      let(:args) { {content_available: true} }
      let(:additional_notification_query_params) { {content_available: "true"} }   
      it { expect(@response.code).to eq 200 }      
    end
  end
end
