require 'rails_helper'

RSpec.describe Address, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#create' do
    before do
      @address = FactoryBot.build(:address)
    end

    it "receiver_blank_error" do
      @address.receiver = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("Receiver can't be blank")
    end

    it "receiver_length_error" do
      @address.receiver = "aaaaaaaaaaaaaaaaaaaaa"
      @address.valid?
      expect(@address.errors.full_messages).to include("Receiver is too long (maximum is 20 characters)")
    end

    it "phone_number_blank_error" do
      @address.phone_number = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("Phone number can't be blank","Phone number must be valid")
    end

    it "phone_number_format_error" do
      @address.phone_number = "123456"
      @address.valid?
      expect(@address.errors.full_messages).to include("Phone number must be valid")
    end

    it "post_code_blank_error" do
      @address.post_code = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("Post code can't be blank","Post code must be valid")
    end

    it "post_code_format_error" do
      @address.post_code = "123456"
      @address.valid?
      expect(@address.errors.full_messages).to include("Post code must be valid")
    end

    it "prefecture_id_blank_error" do
      @address.prefecture_id = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("Prefecture can't be blank")
    end

    it "city_blank_error" do
      @address.city = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("City can't be blank")
    end

    it "detail_blank_error" do
      @address.detail = nil
      @address.valid?
      expect(@address.errors.full_messages).to include("Detail can't be blank")
    end
  end
end
