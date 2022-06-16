require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'img-uploader-bk'
		config.asset_host = Rails.application.credentials.aws_s3[:asset_host]
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws_s3[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws_s3[:secret_access_key],
      region: 'ap-northeast-1',
      path_style: true
    }
end 