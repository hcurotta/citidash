require 'spec_helper'

RSpec.describe Authenticator, type: :service do
  before(:each) do
    @authenticator = Authenticator.new('hcurotta@gmail.com', 'DockDash1')
  end

  context 'when registering', vcr: true do
    it 'should retrieve user details and create a new user' do
      u = @authenticator.register(accepts_terms = true)
      expect(u.first_name).to eq('Harry')
      expect(u.terms_accepted_at).to be_a(Time)
    end
  end

  context 'when logging in successfully', vcr: true do
    context 'logging in without having registered', vcr: true do
      it 'should return nil' do
        u = @authenticator.authenticate_user
        expect(u).to eq(nil)
      end
    end

    it 'should refresh the user details when logging in a second time' do
      user = User.create(email: 'test',
                         password: 'test',
                         first_name: 'ABC',
                         last_name: 'XYZ',
                         citibike_id: 'NU7S9DAK-1')

      @authenticator.authenticate_user
      user.refresh
      expect(user.first_name).to eq('Harry')
    end
  end

  context 'when login fails', vcr: 'true' do
    it 'should set authenticator login to false' do
      bad_authenticator = Authenticator.new('bademail', 'badpassword')
      expect(bad_authenticator.login).to eq(false)
    end
  end
end
