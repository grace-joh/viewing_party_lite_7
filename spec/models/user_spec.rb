require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many(:partygoers) }
    it { should have_many(:parties).through(:partygoers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  describe 'has_secure_password' do
    it { should have_secure_password }

    it 'should not store the password' do
      user = User.create(user_name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')

      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end
  end

  describe 'instance methods' do
    describe '#invitees' do
      it 'returns all users except self' do
        User.delete_all

        @user1 = create(:user)
        @user2 = create(:user)
        @user3 = create(:user)

        expect(@user1.invitees).to eq([@user2, @user3])
      end
    end
  end
end
