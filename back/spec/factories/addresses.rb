FactoryBot.define do
  factory :address do
    user_id { 12 }
    receiver {"achang"}
    phone_number {"080-1234-5678"}
    post_code {"100-1234"}
    detail_address {"東京都新宿区 detailaddress0001"}
    is_default {true}
    prefecture_id { 1 }
    city {"新宿区"}
    detail {"080-1234-5678"}
  end
end