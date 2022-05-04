FactoryBot.define do
  factory :user do
    name { 'achang' }
    email { Faker::Internet.free_email }
    password = Faker::Internet.password(min_length: 6)
    password { password }
    password_confirmation { password }
    is_admin { false }
    is_activated { true }
    phone_number { '080-1234-5678' }
  end
end
