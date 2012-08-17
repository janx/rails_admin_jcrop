module RailsAdminJcrop
  module Orm
    module Extension

      CropFields = [:crop_x, :crop_y, :crop_w, :crop_h, :crop_field]

      def self.included(base)
        base.send :attr_accessor, *CropFields
        base.after_update :rails_admin_crop_callback, :if => :rails_admin_cropping?
      end

      def rails_admin_crop_callback
        ::RailsAdminJcrop::AssetEngine.crop!(self, self.crop_field)
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

if defined?(::ActiveRecord)
  ::ActiveRecord::Base.send(:include, ::RailsAdminJcrop::Orm::Extension)
end

if defined?(::Mongoid)
  module Mongoid
    module Document
      def self.included(base)
        base.send(:include, ::RailsAdminJcrop::Orm::Extension)
      end
    end
  end
end
