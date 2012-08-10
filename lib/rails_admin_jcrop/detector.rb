module RailsAdminJcrop
  class Detector
    class <<self
      def upload_plugin
        return 'CarrierWave' if defined?(CarrierWave) && CarrierWave.respond_to?(:configure)
        return 'Paperclip' if defined?(Paperclip) && Paperclip.respond_to?(:options)
        Rails.logger.warn "[RailsAdminJcrop] Cannot find available upload plugin. (carrierwave or paperclip)"
        nil
      end
    end
  end
end
