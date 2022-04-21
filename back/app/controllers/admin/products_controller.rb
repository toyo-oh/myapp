class Admin::ProductsController < ApplicationController

    before_action :require_login, :require_admin
    
    def create
        @product = Product.new(product_params)
        @product.images = set_images(nil)
        Product.transaction do
            if !@product.save!
                render response_unprocessable_entity(@product.errors)
            end
            promotions = JSON.parse(params[:promotions])
            promotions.each do |p_item|
                @promotion = Promotion.new(
                    product_id: @product.id,
                    start_at: p_item["start_at"],
                    end_at: p_item["end_at"],
                    is_active: p_item["is_active"],
                    discount: p_item["discount"],
                    title: p_item["title"])
                if !@promotion.save!
                    render response_unprocessable_entity(@promotion.errors)
                end
            end
        end
        render json: { code: "ok", message: "add new product successfully!" }
    end

    def index
        @products = Product.all
        render json: { products: @products.as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]) } 
    end

    def show
        @product = find_product
        render :json => {:product => @product.as_json(
            methods: :hashid, 
            except:[:id, :created_at, :updated_at], 
            :include => {:promotions => {methods: [:product_hashid,:hashid], except:[:id, :product_id, :created_at, :updated_at]} })}
    end

    def update
        @product = find_product
        @product.images = set_images(@product.images)
        # @product.tags = set_tags
        Product.transaction do
            if !@product.update!(product_params)
                render response_unprocessable_entity(@product.errors)
            end
            promotions = JSON.parse(params[:promotions])
            promotions.each do |p_item|
                if p_item["start_at"] > Time.new.strftime("%Y-%m-%d")
                    if p_item["hashid"].blank?
                        @promotion = Promotion.new(
                            product_id: @product.id,
                            start_at: p_item["start_at"],
                            end_at: p_item["end_at"],
                            is_active: p_item["is_active"],
                            discount: p_item["discount"],
                            title: p_item["title"])
                        if !@promotion.save!
                            render response_unprocessable_entity(@promotion.errors)
                        end
                    else
                        @promotion = Promotion.find(p_item["hashid"])
                        if !@promotion.update!(
                            product_id: @product.id,
                            start_at: p_item["start_at"],
                            end_at: p_item["end_at"],
                            is_active: p_item["is_active"],
                            discount: p_item["discount"],
                            title: p_item["title"])
                            render response_unprocessable_entity(@promotion.errors)
                        end
                    end
                end
            end
        end
        render json: { code: "ok", message: "updated product successfully!" }
    end

    def destroy
        @product = find_product
        if !@product.destroy 
            render response_unprocessable_entity(@product.errors)
        else
            render json: { code: "ok", message: "deleted product successfully!" }
        end
    end

    def get_categories
        @categories = Category.find_by_sql("SELECT id, category FROM categories")
        render json: @categories
    end

    private
    def product_params
        params.permit(:title, :sub_title, :category_id, :description, :price, :quantity,:tags, {images:[]}, :is_available, {promotions:[]})
    end

    def find_product
        if !params[:id].blank?
            @product = Product.find(params[:id])
          else
            @product = Product.find_by_hashid!(params[:hashid])
          end
        return @product
    end

    def set_images(old_images)
        images = Array.new
        images[0] = params[:image1] if params[:image1]
        images[1] = params[:image2] if params[:image2]
        images[2] = params[:image3] if params[:image3]
        images = old_images if images.blank?
        return images
    end

    def set_tags
        tags = Array.new
        if !params[:tags]
            tags = params[:tags].split(",")
        end
        return tags
    end
end
