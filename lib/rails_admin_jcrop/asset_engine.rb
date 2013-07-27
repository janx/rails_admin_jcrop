if defined?(::CarrierWave)
  require 'rails_admin_jcrop/asset_engine/carrier_wave'
elsif defined?(::Paperclip)
  require 'rails_admin_jcrop/asset_engine/paperclip'
end
