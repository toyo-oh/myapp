class ProductsController < ApplicationController

    before_action :require_login, only: [:add_to_cart, :decrease_of_cart]

    # def index
    #     @products = Product.all
    #     render json: @products
    # end

    def show
        @product = Product.find(params[:id])
        @reviews = @product.reviews
        avg_rate = Review.where(product_id: params[:id]).average("rate")
        @product.discount = ProductsController.get_discount(@product)
        if !@product.tags.blank?
            segments,tags = set_tags_like @product.tags.split(",")
            @related_products = Product.where("(" + segments.join(' OR ') +" OR category_id = ?) AND is_available = 1 AND quantity > 0 AND id <> ?", *tags, @product.category_id, @product.id)
        else
            @related_products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ? AND id <> ?", @product.category_id, @product.id)
        end
        render :json => {:product => @product.as_json(:include => {:reviews => {:include=>{user: {only: :name }}}}),:avg_rate => avg_rate, :related_products =>@related_products}
    end

    def add_to_cart
        @product = Product.find(params[:product_id])
        discount = ProductsController.get_discount(@product)
        @product.price = (@product.price * discount).round(0)
        @current_cart = Cart.find_by(user_id: params[:user_id])
        # cart is not exist
        if @current_cart.blank?
            @new_cart = Cart.new(user_id: params[:user_id])
            Cart.transaction do
                @new_cart.save!
                @new_cart.add_product_to_cart(@product,params[:user_id])
            end
        else
            # cart is alreay exist
            @cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
            if @cart_item.blank?
                @current_cart.add_product_to_cart(@product,params[:user_id])
            else
                new_count = @cart_item.quantity + 1
                @cart_item.update(quantity: new_count)
            end
        end
    end

    def decrease_of_cart
        @current_cart = Cart.find_by(user_id: params[:user_id])
        raise ActiveRecord::RecordNotFound if @current_cart.blank?
        @cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
        if @cart_item.quantity == 1
            @cart_item.destroy
        else
            new_count = @cart_item.quantity - 1
            @cart_item.update(quantity: new_count)
        end
    end

    def search
        if params[:value] == "best_sellers"
            @products = Product.joins('INNER JOIN (SELECT product_id, sum(quantity) as count FROM order_details GROUP BY product_id) order_sum ON products.id = order_sum.product_id where products.is_available = 1 AND products.quantity > 0').order("order_sum.count DESC")
        elsif params[:value] == "new_arrivals"
            @products = Product.where("is_available = 1 AND quantity > 0").order(created_at: :desc)
        elsif params[:value] == "top_rankings"
            @products = Product.joins('INNER JOIN (SELECT product_id ,avg(rate) as avg_rate from reviews GROUP BY product_id) rate_result ON products.id = rate_result.product_id where products.is_available = 1 AND products.quantity > 0').order("rate_result.avg_rate DESC")
        elsif params[:value] == "big_discounts"
            today = Time.new.strftime("%Y-%m-%d")
            @products = Product.find_by_sql(['SELECT * FROM products INNER JOIN (SELECT product_id, sum(discount) as all_discount FROM promotions where start_at <= ? AND end_at >= ? AND is_active = 1 group by product_id) active_promotion ON products.id = active_promotion.product_id where products.is_available = 1 AND products.quantity > 0 ORDER BY active_promotion.all_discount DESC', today, today])
        elsif params[:value] == "category_1"
            @products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 1)
        elsif params[:value] == "category_2"
            @products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 2)
        elsif params[:value] == "category_3"
            @products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 3)
        elsif params[:value] == "category_4"
            @products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 4)
        else
            @products = Product.where("is_available = 1 AND quantity > 0 AND (title LIKE :search OR description LIKE :search)", search: "%#{params[:value]}%")
        end
            @products.each do |item| 
            item.discount = ProductsController.get_discount(item)
        end
        render json: @products
    end

    def index
        limit_cnt_1 = 6
        limit_cnt_2 = 8
        today = Time.new.strftime("%Y-%m-%d")
        # New Arrivals order by created_at desc
        @new_arrivals = Product.where("is_available = 1 AND quantity > 0").order(created_at: :desc).limit(limit_cnt_1)     
        # Best sellers order_details group by product_id sum(quantity) desc
        @best_sellers = Product.joins('INNER JOIN (SELECT product_id, sum(quantity) as count FROM order_details GROUP BY product_id) order_sum ON products.id = order_sum.product_id where products.is_available = 1 AND products.quantity > 0').order("order_sum.count DESC").limit(limit_cnt_1)
        # Top Ratings reviews group by product_id avg(rate) desc
        @top_rankings = Product.joins('INNER JOIN (SELECT product_id ,avg(rate) as avg_rate from reviews GROUP BY product_id) rate_result ON products.id = rate_result.product_id where products.is_available = 1 AND products.quantity > 0').order("rate_result.avg_rate DESC").limit(limit_cnt_1)
        # Big Discounts promotions group by product_id sum(discount)
        @big_discounts = Product.find_by_sql(['SELECT * FROM products INNER JOIN (SELECT product_id, sum(discount) as all_discount FROM promotions where start_at <= ? AND end_at >= ? AND is_active = 1 group by product_id) active_promotion ON products.id = active_promotion.product_id where products.is_available = 1 AND products.quantity > 0 ORDER BY active_promotion.all_discount DESC limit ?', today, today, limit_cnt_1])
        @category_1 = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 1).limit(limit_cnt_2)
        @category_2 = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 2).limit(limit_cnt_2)
        @category_3 = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 3).limit(limit_cnt_2)
        @category_4 = Product.where("is_available = 1 AND quantity > 0 AND category_id = ?", 4).limit(limit_cnt_2)
        render :json => {:new_arrivals => set_discount_to_list(@new_arrivals), 
                        :best_sellers => set_discount_to_list(@best_sellers), 
                        :top_rankings =>set_discount_to_list(@top_rankings), 
                        :big_discounts =>set_discount_to_list(@big_discounts),
                        :category_1 => set_discount_to_list(@category_1), 
                        :category_2 => set_discount_to_list(@category_2), 
                        :category_3 => set_discount_to_list(@category_3), 
                        :category_4 => set_discount_to_list(@category_4)}
    end

    def self.get_discount(product)
        discount = 1;
        if !product.promotions.blank?
            today = Time.new.strftime("%Y-%m-%d")
            promotions = Promotion.where('product_id = ? AND start_at <= ? AND end_at >= ? AND is_active = 1', product.id, today, today)
            if !promotions.blank?
                tmp_discount = 0
                promotions.each do |p_item|
                    tmp_discount += 1 - p_item.discount;
                end
                discount = tmp_discount > 0.5 ? 0.5 : 1 - tmp_discount;
            end
        end
        return discount
    end

    def set_discount_to_list(products)
        products.each do|item| 
            item.discount = ProductsController.get_discount(item)
        end
        return products
    end

    private
    def set_tags_like(tags)
        segments = []
        tags = tags.map{ |tag|
            segments.push('tags LIKE ?')
            "%#{tag}%"
        }
        return segments, tags
    end

end
