FactoryBot.define do
  factory :product do
    title { "tile" }
    sub_title {"sub title"}
    category_id {1}
    description {"test description"}
    price {100}
    quantity {10}
  end
end
