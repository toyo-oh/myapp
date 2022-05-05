require 'uri'
require 'net/http'
require 'openssl'

class OrderTrackingNano
  def self.order_tracking
    # yamato
    @shipping_yamato = Order.where(aasm_state: 'shipping', slug: 'taqbin-jp')
    length_yamato = @shipping_yamato.size
    puts length_yamato
    trackings = []
    @shipping_yamato.each do |item|
      puts Time.new
      puts item.tracking_number
      result = request_nanoapi(item.tracking_number)
      resolve_result(result, trackings)
      sleep(2)
    end

    ActiveRecord::Base.transaction do
      trackings.each do |item|
        Order.where(slug: item.slug, tracking_number: item.tracking_number, aasm_state: 'shipping')
             .update_all(aasm_state: item.tag, updated_at: Time.new)
      end
    end
  end

  def self.request_nanoapi(number)
    url = URI("http://nanoappli.com/tracking/api/#{number}.json")
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    http.request(request).read_body
  end

  def self.resolve_result(result, trackings)
    json_result = JSON.parse(result)
    puts json_result
    if json_result['result'] == '0' && json_result['status'] == '配達完了'
      tracking = TrackingResult.new
      tracking.slug = 'taqbin-jp'
      tracking.tracking_number = json_result['slipNo']
      tracking.tag = 'delivered'
      trackings << tracking
    end
  end
end
