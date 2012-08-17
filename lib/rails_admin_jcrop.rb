require "rails_admin_jcrop/detector"
require "rails_admin_jcrop/engine"

require 'rails_admin_jcrop/orm/active_record' if defined?(::ActiveRecord)
require 'rails_admin_jcrop/orm/mongoid' if defined?(::Mongoid)

require 'rails_admin_jcrop/extensions/carrier_wave' if defined?(::CarrierWave)
require 'rails_admin_jcrop/extensions/paperclip' if defined?(::Paperclip)

require 'rails_admin_jcrop/extensions/rails_admin'
