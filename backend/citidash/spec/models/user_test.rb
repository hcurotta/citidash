require 'spec_helper'

RSpec.describe User, :type => :model do
  it "retrieves user details and creates a new user" do 
    u = User.setup_user("abc@example.com", "abcxyz")
    expect(u.first_name).to eq("Harry")
  end
end