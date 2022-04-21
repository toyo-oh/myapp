require 'active_model'

class TrackingResult
	include ActiveModel::Model
  include ActiveModel::Attributes
	
	attr_accessor :slug
	attr_accessor :tracking_number
	attr_accessor :tag

end