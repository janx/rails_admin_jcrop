module RailsAdminJcrop
  class Detector
    class <<self
      def upload_plugin
        return 'CarrierWave' if defined?(CarrierWave) && CarrierWave.respond_to?(:configure)
        return 'Paperclip' if defined?(Paperclip) && Paperclip.respond_to?(:options)
        Rails.logger.warn "[RailsAdminJcrop] Cannot find available upload plugin. (CarrierWave or Paperclip)"
        nil
      end

      def image_plugin
        return 'MiniMagick' if defined?(MiniMagick)
        return 'RMagick' if defined?(Magick)
        Rails.logger.warn "[RailsAdminJcrop] Cannot find available image plugin. (MiniMagick or RMagick)"
        nil
      end
    end
  end
end
