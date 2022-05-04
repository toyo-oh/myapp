require 'active_model'

class TrackingResult
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :slug, :tracking_number, :tag
end
