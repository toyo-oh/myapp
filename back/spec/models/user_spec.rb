require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it 'email_blank_error' do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank", 'Email must be valid')
    end

    it 'email_format_error' do
      @user.email = 'test'
      @user.valid?
      expect(@user.errors.full_messages).to include('Email must be valid')
    end

    it 'name_blank_error' do
      @user.name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Name can't be blank")
    end

    it 'name_length_error' do
      @user.name = 'aaaaaaaaaaa'
      @user.valid?
      expect(@user.errors.full_messages).to include('Name is too long (maximum is 10 characters)')
    end

    it 'password_blank_error' do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank",
                                                    'Password is too short (minimum is 6 characters)', 
                                                    "Password confirmation doesn't match Password")
    end

    it 'password_length_error' do
      @user.password = '123'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'password_confirmation_blank_error' do
      @user.password_confirmation = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation can't be blank",
                                                    'Password confirmation is too short (minimum is 6 characters)')
    end

    it 'password_confirmation_unequal_error' do
      @user.password_confirmation = '111111'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
  end
end
