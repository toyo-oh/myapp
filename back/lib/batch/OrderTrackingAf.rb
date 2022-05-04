require 'uri'
require 'net/http'
require 'openssl'

class OrderTrackingAf
  def self.order_tracking
    # sagawa
    @shipping_sagawa = Order.where(aasm_state: 'shipping', slug: 'sagawa')
    length_sagawa = @shipping_sagawa.size
    puts length_sagawa
    i = 0
    count = length_sagawa / 100
    remainder = length_sagawa % 100
    count += 1 if remainder > 0
    trackings = []
    while i < count
      numbers = if length_sagawa - i * 100 < 100
                  concat_numbers(@shipping_sagawa[i * 100..length_sagawa - 1])
                else
                  concat_numbers(@shipping_sagawa[i * 100..i * 100 + 99])
                end
      puts numbers
      results = request_aftership('sagawa', numbers)
      puts results
      resolve_result(results, trackings)
      i += 1
    end

    ActiveRecord::Base.transaction do
      puts trackings.size
      trackings.each do |item|
        if item.tag == 'delivered'
          Order.where(slug: item.slug, tracking_number: item.tracking_number, aasm_state: 'shipping')
               .update_all(aasm_state: item.tag, updated_at: Time.new)
        end
      end
    end

    # TODO: takubin
  end

  def self.request_aftership(slug, numbers)
    url = URI("https://api.aftership.com/v4/trackings/?page=1&limit=100&tracking_numbers=#{numbers}&slug=#{slug}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    puts ENV['AFTERSHIP_PK']
    request['aftership-api-key'] = ENV['AFTERSHIP_PK']

    http.request(request).read_body
  end

  def self.concat_numbers(orders)
    numbers = ''
    orders.each do |item|
      if numbers.blank?
        numbers << item.tracking_number
      else
        numbers << '%2C'
        numbers << item.tracking_number
      end
    end
    numbers
  end

  def self.resolve_result(results, trackings)
    json_results = JSON.parse(results)['data']['trackings']
    puts json_results
    json_results.each do |item|
      tracking = TrackingResult.new
      tracking.slug = item['slug']
      tracking.tracking_number = item['tracking_number']
      tracking.tag = item['tag'].downcase
      trackings << tracking
    end
  end
end
