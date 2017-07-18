require 'spec_helper'

RSpec.describe Authenticator, :type => :service do
  context 'when logging in successfully' do
    use_vcr_cassette "login"

    before(:each) do 
      @authenticator = Authenticator.new("joebloggs@gmail.com", "testpassword")
    end

    it "should retrieve user details and create a new user" do 
      u = @authenticator.authenticate_user
      expect(u.first_name).to eq("Harry")
    end

    it "should refresh the user details when logging in a second time" do 
      user = User.create({
        :email=>"test",
        :password=>"test",
        :first_name=>"ABC",
        :last_name=>"XYZ",
        :citibike_id=>"NU7S9DAK-1"
      })

      @authenticator.authenticate_user
      user.refresh
      expect(user.first_name).to eq("Harry")
    end
  end

  context 'when login fails' do
    use_vcr_cassette "failed login"

    it "should set authenticator login to false" do 
      authenticator = Authenticator.new("bademail", "badpassword")
      expect(authenticator.login).to eq(false)
    end
  end
end