class OrderStatus < ApplicationRecord
  enum order_status: { order_placed: 0, paid: 1, shipping: 2, delivered: 3, order_cancelled: 4, good_returned: 5 }
end
