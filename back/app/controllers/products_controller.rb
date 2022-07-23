class ProductsController < ApplicationController
  before_action :require_login,
                only: %i[add_to_cart decrease_of_cart add_favourite cancel_favourite list_favourites_by_user_id]

  def show
    @product = find_product
    @reviews = @product.reviews
    avg_rate = Review.where(product_id: @product.id).average('rate')
    # discount
    @product.discount = ProductsController.cal_discount(@product)
    # related_products
    if !@product.tags.blank?
      segments, tags = concat_tags_like @product.tags.split(',')
      @related_products = Product.where(
        format('(%s OR category_id = ?) AND is_available = 1 AND quantity > 0 AND id <> ?', segments.join(' OR ')), 
        *tags, @product.category_id, @product.id
      )
    else
      @related_products = Product.where('is_available = 1 AND quantity > 0 AND category_id = ? AND id <> ?',
                                        @product.category_id, @product.id)
    end
    # is_fav
    is_fav = false
    if decoded_token.present?
      user_id = decoded_token[0]['user_id']
      @fav = Favourite.find_by(user_id: user_id, product_id: @product.id)
      is_fav = true unless @fav.blank?
    end
    render json: { product: @product.as_json(
      methods: :hashid,
      except: %i[id created_at updated_at],
      include: { reviews: { only: %i[rate comment created_at], include: { user: { only: :name } } } }
    ),
      avg_rate: avg_rate,
      is_fav: is_fav,
      related_products: discount_setting(@related_products).as_json(methods: :hashid,
                                                                    except: %i[id created_at updated_at]) }
  end

  def add_to_cart
    user_id = decode_user_id(params[:user_id])
    @product = Product.find(params[:product_id])
    discount = ProductsController.cal_discount(@product)
    @product.price = (@product.price * (1 - discount)).round(0)
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
    render json: { code: 'ok', message: 'increased item successfully!' }
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
    render json: { code: 'ok', message: 'decreased item successfully!' }
  end

  def search
    case params[:value] 
    when 'best_sellers'
      @products = Product.joins('INNER JOIN (SELECT product_id, sum(quantity) as count FROM order_details GROUP BY product_id) order_sum ON products.id = order_sum.product_id where products.is_available = 1 AND products.quantity > 0').order('order_sum.count DESC')
    when 'new_arrivals'
      @products = Product.where('is_available = 1 AND quantity > 0').order(created_at: :desc)
    when 'top_rankings'
      @products = Product.joins('INNER JOIN (SELECT product_id ,avg(rate) as avg_rate from reviews GROUP BY product_id) rate_result ON products.id = rate_result.product_id where products.is_available = 1 AND products.quantity > 0').order('rate_result.avg_rate DESC')
    when 'big_discounts'
      today = Time.new.strftime('%Y-%m-%d')
      @products = Product.find_by_sql([
                                        'SELECT * FROM products INNER JOIN (SELECT product_id, sum(discount) as all_discount FROM promotions where start_at <= ? AND end_at >= ? AND is_active = 1 group by product_id) active_promotion ON products.id = active_promotion.product_id where products.is_available = 1 AND products.quantity > 0 ORDER BY active_promotion.all_discount DESC', today, today
                                      ])
    when /^category_/
      @products = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ?', params[:value][9, params[:value].length]])
    else
      @products = Product.where(
        'is_available = 1 AND quantity > 0 AND (title LIKE :search OR description LIKE :search)', 
        search: "%#{params[:value]}%"
      )
    end
    @products.each do |item|
      item.discount = ProductsController.cal_discount(item)
    end
    render json: { products: @products.as_json(methods: [:hashid], except: %i[id created_at updated_at]) }
  end

  def index
    limit_cnt1 = 8
    limit_cnt2 = 8
    today = Time.new.strftime('%Y-%m-%d')
    # New Arrivals order by created_at desc
    @new_arrivals = Product.where('is_available = 1 AND quantity > 0').order(created_at: :desc).limit(limit_cnt1)
    # Best sellers order_details group by product_id sum(quantity) desc
    @best_sellers = Product.joins('INNER JOIN (SELECT product_id, sum(quantity) as count FROM order_details GROUP BY product_id) order_sum 
                                  ON products.id = order_sum.product_id where products.is_available = 1 AND products.quantity > 0')
                                  .order('order_sum.count DESC').limit(limit_cnt1)
    # Top Ratings reviews group by product_id avg(rate) desc
    @top_rankings = Product.joins('INNER JOIN (SELECT product_id ,avg(rate) as avg_rate from reviews GROUP BY product_id) rate_result 
                                  ON products.id = rate_result.product_id where products.is_available = 1 AND products.quantity > 0')
                                  .order('rate_result.avg_rate DESC').limit(limit_cnt1)
    # Big Discounts promotions group by product_id sum(discount)
    @big_discounts = Product.find_by_sql([
                                           'SELECT * FROM products 
                                           INNER JOIN (SELECT product_id, sum(discount) as all_discount FROM promotions 
                                           where start_at <= ? AND end_at >= ? AND is_active = 1 group by product_id) active_promotion 
                                           ON products.id = active_promotion.product_id 
                                           where products.is_available = 1 AND products.quantity > 0 ORDER BY active_promotion.all_discount DESC limit ?', 
                                           today, today, limit_cnt1
                                         ])
    @coffeeBeans = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'CoffeeBeans',limit_cnt2])
    @dripBag = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'DripBag',limit_cnt2])
    @liquidCoffee = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'LiquidCoffee',limit_cnt2])
    @instantCoffee = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'InstantCoffee',limit_cnt2])
    @sugarMilk = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'Sugar&Milk',limit_cnt2])
    @coffeeTools = Product.find_by_sql(['SELECT * FROM products INNER JOIN categories on products.category_id = categories.id where products.is_available = 1 AND products.quantity > 0 AND categories.category = ? limit ?', 'CoffeeTools',limit_cnt2])
    # slide products
    slide_config = Rails.application.config_for(:promotion, env: Rails.env)
    @slide_products = Product.find(slide_config['slide_products'])
    render json: { new_arrivals: discount_setting(@new_arrivals).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   best_sellers: discount_setting(@best_sellers).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   top_rankings: discount_setting(@top_rankings).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   big_discounts: discount_setting(@big_discounts).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   coffeeBeans: discount_setting(@coffeeBeans).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   dripBag: discount_setting(@dripBag).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   liquidCoffee: discount_setting(@liquidCoffee).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   instantCoffee: discount_setting(@instantCoffee).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   sugarMilk: discount_setting(@sugarMilk).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   coffeeTools: discount_setting(@coffeeTools).as_json(methods: [:hashid], except: %i[id created_at updated_at]),
                   slide_products: discount_setting(@slide_products).as_json(methods: [:hashid], except: %i[id created_at updated_at]) }
  end

  def self.cal_discount(product)
    discount = 0
    unless product.promotions.blank?
      today = Time.new.strftime('%Y-%m-%d')
      promotions = Promotion.where('product_id = ? AND start_at <= ? AND end_at >= ? AND is_active = 1',
                                   product.id, today, today)
      unless promotions.blank?
        tmp_discount = 0
        promotions.each do |p_item|
          tmp_discount += 1 - p_item.discount
        end
        discount = tmp_discount > 0.5 ? 0.5 : tmp_discount
      end
    end
    discount
  end

  def discount_setting(products)
    products.each do |item|
      item.discount = ProductsController.cal_discount(item)
    end
    products
  end

  def add_favourite
    user_id = decode_user_id(params[:user_id])
    product_id = decode_product_id(params[:product_id])
    @current_fav = Favourite.find_by(user_id: user_id, product_id: product_id)
    if @current_fav.blank?
      favourite = Favourite.new
      favourite.user_id = user_id
      favourite.product_id = product_id
      if favourite.save!
        render json: { code: 'ok', message: 'add to favourite successfully!' }
      else
        render response_unprocessable_entity(favourite.errors)
      end
    else
      render json: { code: 'error', message: 'the product is already in favourite!' }
    end
  end

  def cancel_favourite
    user_id = decode_user_id(params[:user_id])
    product_id = decode_product_id(params[:product_id])
    @current_fav = Favourite.find_by(user_id: user_id, product_id: product_id)
    if @current_fav.blank?
      render json: { code: 'error', message: 'the product is not in favourite!' }
    elsif @current_fav.destroy!
      render json: { code: 'ok', message: 'cancel favourite successfully!' }
    else
      render response_unprocessable_entity(@current_fav.errors)
    end
  end

  def list_favourites_by_user_id
    user_id = decode_user_id(params[:user_id])
    @products = Product.joins('INNER JOIN favourites ON favourites.product_id = products.id').where(
      'favourites.user_id = ?', user_id
    )
    render json: { products: discount_setting(@products).as_json(methods: [:hashid], except: %i[id created_at updated_at]) }
  end

  private

  def find_product
    @product = if !params[:id].blank?
                 Product.find(params[:id])
               else
                 Product.find_by_hashid!(params[:hashid])
               end
    @product
  end

  def concat_tags_like(tags)
    segments = []
    tags = tags.map do |tag|
      segments.push('tags LIKE ?')
      "%#{tag}%"
    end
    [segments, tags]
  end
end
