class ProductsController < ApplicationController

    before_action :require_login, only: [:add_to_cart, :decrease_of_cart, :add_favourite, :cancel_favourite, :get_favourites_by_user_id]

    def show
        @product = find_product
        @reviews = @product.reviews
        avg_rate = Review.where(product_id: @product.id).average("rate")
        #discount
        @product.discount = ProductsController.get_discount(@product)
        #related_products
        if !@product.tags.blank?
            segments,tags = set_tags_like @product.tags.split(",")
            @related_products = Product.where("(" + segments.join(' OR ') +" OR category_id = ?) AND is_available = 1 AND quantity > 0 AND id <> ?", *tags, @product.category_id, @product.id)
        else
            @related_products = Product.where("is_available = 1 AND quantity > 0 AND category_id = ? AND id <> ?", @product.category_id, @product.id)
        end
        # is_fav
        is_fav = false
        if decoded_token.present?
            user_id = decoded_token[0]['user_id']
            @fav = Favourite.find_by(user_id: user_id, product_id: @product.id)
            if !@fav.blank?
                is_fav = true
            end
        end
        render :json => {:product => @product.as_json(
            methods: :hashid, 
            except:[:id, :created_at, :updated_at], 
            :include => {:reviews => {only: [:rate, :comment, :created_at], :include=>{user: {only: :name }}}}),
            :avg_rate => avg_rate,
            :is_fav => is_fav,
            :related_products =>set_discount_to_list(@related_products).as_json(methods: :hashid, except:[:id, :created_at, :updated_at])
        }
    end

    def add_to_cart
        user_id = decode_user_id(params[:user_id])
        @product = Product.find(params[:product_id])
        discount = ProductsController.get_discount(@product)
        @product.price = (@product.price * (1-discount)).round(0)
        @current_cart = Cart.find_by(user_id: user_id)
        # cart is not exist
        if @current_cart.blank?
            @new_cart = Cart.new(user_id: user_id)
            Cart.transaction do
                @new_cart.save!
                @new_cart.add_product_to_cart(@product, user_id)
            end
        else
            # cart is alreay exist
            @cart_item = @current_cart.cart_items.find_by(product_id: @product.id)
            if @cart_item.blank?
                @current_cart.add_product_to_cart(@product, user_id)
            else
                new_count = @cart_item.quantity + 1
                @cart_item.update(quantity: new_count)
            end
        end
        render json: {code: "ok", message: "increased item successfully!" }
    end

    def decrease_of_cart
        user_id = decode_user_id(params[:user_id])
        product_id = decode_product_id(params[:product_id])
        @current_cart = Cart.find_by(user_id: user_id)
        raise ActiveRecord::RecordNotFound if @current_cart.blank?
        @cart_item = @current_cart.cart_items.find_by(product_id: product_id)
        if @cart_item.quantity == 1
            @cart_item.destroy
        else
            new_count = @cart_item.quantity - 1
            @cart_item.update(quantity: new_count)
        end
        render json: {code: "ok", message: "decreased item successfully!" }
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
        render json: { products: @products.as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]) } 
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
        render :json => {:new_arrivals => set_discount_to_list(@new_arrivals).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :best_sellers => set_discount_to_list(@best_sellers).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :top_rankings =>set_discount_to_list(@top_rankings).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :big_discounts =>set_discount_to_list(@big_discounts).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]),
                        :category_1 => set_discount_to_list(@category_1).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :category_2 => set_discount_to_list(@category_2).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :category_3 => set_discount_to_list(@category_3).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at]), 
                        :category_4 => set_discount_to_list(@category_4).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at])}
    end

    def self.get_discount(product)
        discount = 0;
        if !product.promotions.blank?
            today = Time.new.strftime("%Y-%m-%d")
            promotions = Promotion.where('product_id = ? AND start_at <= ? AND end_at >= ? AND is_active = 1', product.id, today, today)
            if !promotions.blank?
                tmp_discount = 0
                promotions.each do |p_item|
                    tmp_discount += 1 - p_item.discount;
                end
                discount = tmp_discount > 0.5 ? 0.5 : tmp_discount;
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

    def add_favourite
        user_id = decode_user_id(params[:user_id])
        product_id = decode_product_id(params[:product_id])
        @current_fav = Favourite.find_by(user_id: user_id, product_id: product_id)
        if  @current_fav.blank?
            favourite = Favourite.new
            favourite.user_id = user_id
            favourite.product_id = product_id
            if favourite.save!
                render json: { code: "ok", message: "add to favourite successfully!" }
            else
                render response_unprocessable_entity(favourite.errors)
            end
        else
            render json: { code: "error", message: "the product is already in favourite!" }
        end
    end

    def cancel_favourite
        user_id = decode_user_id(params[:user_id])
        product_id = decode_product_id(params[:product_id])
        @current_fav = Favourite.find_by(user_id: user_id, product_id: product_id)
        if  @current_fav.blank?
            render json: { code: "error", message: "the product is not in favourite!" }
        else
            if @current_fav.destroy!
                render json: { code: "ok", message: "cancel favourite successfully!" }
            else
                render response_unprocessable_entity(@current_fav.errors)
            end
        end
    end

    def get_favourites_by_user_id
        user_id = decode_user_id(params[:user_id])
        @products = Product.joins("INNER JOIN favourites ON favourites.product_id = products.id").where("favourites.user_id = ?", user_id);
        render :json => {:products => set_discount_to_list(@products).as_json(methods: [:hashid], except:[:id, :created_at, :updated_at])}
	end

    private
    def find_product
        if !params[:id].blank?
            @product = Product.find(params[:id])
          else
            @product = Product.find_by_hashid!(params[:hashid])
          end
        return @product
    end

    def set_tags_like(tags)
        segments = []
        tags = tags.map{ |tag|
            segments.push('tags LIKE ?')
            "%#{tag}%"
        }
        return segments, tags
    end

end
