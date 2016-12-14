require 'spec_helper'

describe Notifiable::Sender::V1 do
  
  let(:access_id) { "abc123" }
  let(:base_uri) { "http://notifiable.com" }
  let(:query) { {} }
  subject { Notifiable::Sender::V1.new(base_uri, access_id) }
  
  describe "#send_notification" do
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(query: {notification: query}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_notification(query)
    end    
    
    context "with message" do
      let(:query) { {message: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with parameters" do
      let(:query) { {parameters: "{flow_id: 5}"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with filters" do
      let(:query) { {filters: "[{\"property\": \"lat\", \"predicate\": \"lt\", \"value\": 40.3}]"} }      
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with content_avaliable" do
      let(:query) { {content_avaliable: true} }      
      it { expect(@response.code).to eq 200 }      
    end
  end
  
  describe "#send_notification_to_user" do
    let(:user_alias) { "matt@futureworkshops.com" }
    let(:additional_query) { {} }
    let(:query) { additional_query.merge({filters: "[{\"property\": \"user_alias\", \"predicate\": \"eq\", \"value\": \"#{user_alias}\"}]"}) }
    
    before(:each) do
      stub_request(:post, "http://notifiable.com/api/v1/notifications").
               with(query: {notification: query}).
               with(:headers => {'Authorization'=>'abc123'}).
               to_return(status: 200)
    
      @response = subject.send_notification_to_user(user_alias, additional_query)
    end 
    
    context "with message" do
      let(:additional_query) { {message: "New Offers"} }
      it { expect(@response.code).to eq 200 }      
    end
    
    context "with parameters" do
      let(:additional_query) { {parameters: "{flow_id: 1}"} }
      it { expect(@response.code).to eq 200 }      
    end
  end
end
