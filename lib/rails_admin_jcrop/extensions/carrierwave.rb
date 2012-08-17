module RailsAdminJcrop
  module Extensions
    module CarrierWave
      class <<self
        def thumbnail_names(obj, field)
          obj.class.uploaders[field.to_sym].versions.keys
        end
      end

      def rails_admin_crop
        return unless model.rails_admin_cropping?
        manipulate! do |img|
          geometry = "#{model.crop_w}x#{model.crop_h}+#{model.crop_x}+#{model.crop_y}"
          img.crop geometry
          img
        end
      end
    end
  end
end

module CarrierWave
  module Mount
    module Extension
      def self.included(base)
        base.uploaders.each do |name, klass|
          klass.send :include, RailsAdminJcrop::Extensions::CarrierWave
        end
      end
    end
  end
end
