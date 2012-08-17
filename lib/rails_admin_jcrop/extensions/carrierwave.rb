module RailsAdminJcrop
  module Extensions
    module CarrierWave
      class <<self
        def thumbnail_names(obj, field)
          obj.class.uploaders[field.to_sym].versions.map(&:name)
        end
      end
    end
  end
end

module CarrierWave
  module Mount
    module Extension
      def self.included(base)
        base.send :include, RailsAdminJcrop::Orm::ActiveRecord
      end
    end
  end
end
