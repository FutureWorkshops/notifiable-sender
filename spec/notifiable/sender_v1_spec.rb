require 'spec_helper'

describe Notifiable::Sender::V1 do
  
  describe "#send_notification" do
    let(:access_id) { "abc123" }
    let(:base_uri) { "http://notifiable.com" }
    subject { Notifiable::Sender::V1.new(base_uri, access_id) }
    
    context "with message" do
      before(:each) do
      
        stub_request(:post, "http://notifiable.com/api/v1/notifications").
                 with(query: {notification: {message: "New offers!"}}).
                 with(:headers => {'Authorization'=>'abc123'}).
                 to_return(status: 200)
      
        @response = subject.send_notification(message: "New offers!")
      end
    
      it { expect(@response.code).to eq 200 }      
    end
  end
end
