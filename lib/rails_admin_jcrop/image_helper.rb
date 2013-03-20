filename = defined?(::Magick) ? 'rmagick' : 'minimagick'
require "rails_admin_jcrop/image_helper/#{filename}"
