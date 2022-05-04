require 'rails_helper'

RSpec.describe Product, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#create' do
    before do
      @product = FactoryBot.build(:product)
    end

    it 'title_blank_error' do
      @product.title = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Title can't be blank")
    end

    it 'title_length_error' do
      @product.title = 'aaaaaaaaaaa'
      @product.valid?
      expect(@product.errors.full_messages).to include('Title is too long (maximum is 10 characters)')
    end

    it 'sub_title_blank_error' do
      @product.sub_title = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Sub title can't be blank")
    end
‰
    it 'category_id_blank_error' do
      @product.category_id = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end

    it 'description_blank_error' do
      @product.description = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Description can't be blank")
    end

    it 'price_blank_error' do
      @product.price = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Price can't be blank")
    end

    it 'price_value_error' do
      @product.price = 100_000_000
      @product.valid?
      expect(@product.errors.full_messages).to include('Price must be less than or equal to 99999999')
    end

    it 'quantity_blank_error' do
      @product.quantity = nil
      @product.valid?
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end

    it 'quantity_value_error' do
      @product.quantity = 100_000_000
      @product.valid?
      expect(@product.errors.full_messages).to include('Quantity must be less than or equal to 99999999')
    end
  end
end
