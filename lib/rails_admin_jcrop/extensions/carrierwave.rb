module CarrierWave
  module Mount
    module Extension
      def self.included(base)
        base.send :include, RailsAdminJcrop::Orm::ActiveRecord
      end
    end
  end
end
