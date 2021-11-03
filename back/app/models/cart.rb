class Cart < ApplicationRecord
    has_many :cart_items
    has_many :products, through: :cart_items, source: :product
    belongs_to :user

    # TODO?
    def add_product_to_cart(product, user_id)
        ci = cart_items.build
        ci.product = product
        ci.quantity = 1
        ci.save
    end
    # def update_cart_count()
    #     ci = cart.
    #     ci.quantity += 1
    #     ci.update
    # end
end
