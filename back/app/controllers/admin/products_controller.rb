class Admin::ProductsController < ApplicationController

    before_action :require_login, :require_admin
    
    def create
        @product = Product.new(product_params)
        @product.images = set_images(nil)
        # @product.tags = set_tags
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
    end

    def index
        @products = Product.all
        render json: @products
    end

    def show
        @product = Product.find(params[:id])
        render :json => {:product => @product.as_json(:include => :promotions)}
    end

    def update
        @product = Product.find(params[:id])
        @product.images = set_images(@product.images)
        # @product.tags = set_tags
        Product.transaction do
            if !@product.update!(product_params)
                render response_unprocessable_entity(@product.errors)
            end
            promotions = JSON.parse(params[:promotions])
            promotions.each do |p_item|
                if p_item["start_at"] > Time.new.strftime("%Y-%m-%d")
                    if p_item["id"].blank?
                        @promotion = Promotion.new(
                            product_id: p_item["product_id"],
                            start_at: p_item["start_at"],
                            end_at: p_item["end_at"],
                            is_active: p_item["is_active"],
                            discount: p_item["discount"],
                            title: p_item["title"])
                        if !@promotion.save!
                            render response_unprocessable_entity(@promotion.errors)
                        end
                    else
                        @promotion = Promotion.find(p_item["id"])
                        if !@promotion.update!(
                            product_id: p_item["product_id"],
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
    end

    def destroy
        @product = Product.find(params[:id])
        if !@product.destroy 
            render response_unprocessable_entity(@product.errors)
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
