class Admin::ProductsController < ApplicationController
  before_action :require_login, :require_admin

  def create
    @product = Product.new(product_params)
    @product.images = set_images(nil)
    Product.transaction do
      render response_unprocessable_entity(@product.errors) unless @product.save!
      promotions = JSON.parse(params[:promotions])
      promotions.each do |p_item|
        @promotion = Promotion.new(
          product_id: @product.id,
          start_at: p_item['start_at'],
          end_at: p_item['end_at'],
          is_active: p_item['is_active'],
          discount: p_item['discount'],
          title: p_item['title']
        )
        render response_unprocessable_entity(@promotion.errors) unless @promotion.save!
      end
    end
    render json: { code: 'ok', message: 'add new product successfully!' }
  end

  def index
    @products = Product.all
    render json: { products: @products.as_json(methods: [:hashid], except: %i[id created_at updated_at]) }
  end

  def show
    @product = find_product
    render json: { product: @product.as_json(
      methods: :hashid,
      except: %i[id created_at updated_at],
      include: { promotions: { methods: %i[product_hashid hashid],
                               except: %i[id product_id created_at updated_at] } }
    ) }
  end

  def update
    @product = find_product
    @product.images = set_images(@product.images)
    # @product.tags = set_tags
    Product.transaction do
      render response_unprocessable_entity(@product.errors) unless @product.update!(product_params)
      promotions = JSON.parse(params[:promotions])
      promotions.each do |p_item|
        if p_item['start_at'] > Time.new.strftime('%Y-%m-%d')
          if p_item['hashid'].blank?
            @promotion = Promotion.new(
              product_id: @product.id,
              start_at: p_item['start_at'],
              end_at: p_item['end_at'],
              is_active: p_item['is_active'],
              discount: p_item['discount'],
              title: p_item['title']
            )
            render response_unprocessable_entity(@promotion.errors) unless @promotion.save!
          else
            @promotion = Promotion.find(p_item['hashid'])
            unless @promotion.update!(
              product_id: @product.id,
              start_at: p_item['start_at'],
              end_at: p_item['end_at'],
              is_active: p_item['is_active'],
              discount: p_item['discount'],
              title: p_item['title']
            )
              render response_unprocessable_entity(@promotion.errors)
            end
          end
        end
      end
    end
    render json: { code: 'ok', message: 'updated product successfully!' }
  end

  def destroy
    @product = find_product
    if !@product.destroy
      render response_unprocessable_entity(@product.errors)
    else
      render json: { code: 'ok', message: 'deleted product successfully!' }
    end
  end

  def get_categories
    @categories = Category.find_by_sql('SELECT id, category FROM categories')
    render json: @categories
  end

  private

  def product_params
    params.permit(:title, :sub_title, :category_id, :description, :price, :quantity, :tags, :property, { images: [] },
                  :is_available, { promotions: [] })
  end

  def find_product
    @product = if !params[:id].blank?
                 Product.find(params[:id])
               else
                 Product.find_by_hashid!(params[:hashid])
               end
    @product
  end

  def set_images(old_images)
    images = []
    images[0] = params[:image1] if params[:image1]
    images[1] = params[:image2] if params[:image2]
    images[2] = params[:image3] if params[:image3]
    images = old_images if images.blank?
    images
  end

  def set_tags
    tags = []
    tags = params[:tags].split(',') unless params[:tags]
    tags
  end
end
