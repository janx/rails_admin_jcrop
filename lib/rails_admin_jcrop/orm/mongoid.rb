module RailsAdminJcrop
  module Orm
    module Mongoid

      CropFields = [:crop_x, :crop_y, :crop_w, :crop_h, :crop_field]

      def self.included(base)
        base.send :attr_accessor, *CropFields
        base.after_update :rails_admin_crop_callback, :if => :rails_admin_cropping?

        base.attachment_definitions.each do |name, options|
          options[:processors] ||= []
          options[:processors] << :rails_admin_jcrop_cropper
        end
      end

      def rails_admin_crop_callback
        self.send(self.crop_field).reprocess!
      end

      def rails_admin_cropping?
        CropFields.all? {|f| send(f).present?}
      end

      def rails_admin_crop!(params)
        CropFields.each {|f| self.send "#{f}=", params[f] }
        save!
      end

    end
  end
end
