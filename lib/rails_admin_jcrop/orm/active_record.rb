module RailsAdminJcrop
  module Orm
    module ActiveRecord

      CropFields = [:crop_x, :crop_y, :crop_w, :crop_h, :crop_field]

      def self.included(base)
        base.send :attr_accessor, *CropFields
        base.after_update :rails_admin_crop_callback, :if => :rails_admin_cropping?

        base.uploaders.each do |name, klass|
          klass.send :include, CarrierWaveUploaderMixin
        end
      end

      def rails_admin_crop_callback
        self.send(self.crop_field).recreate_versions!
      end

      def rails_admin_cropping?
        CropFields.all? {|f| send(f).present?}
      end

      def rails_admin_crop!(params)
        CropFields.each {|f| self.send "#{f}=", params[f] }
        save!
      end

      module CarrierWaveUploaderMixin
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
end
