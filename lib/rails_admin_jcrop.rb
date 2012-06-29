require "rails_admin_jcrop/engine"

module RailsAdminJcrop
end

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module ActiveRecordMixin
    #http://stackoverflow.com/questions/5985079/carrierwave-crop-specific-version
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

  module Config
    module Fields
      module Types
        class Jcrop < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:partial) do
            :form_jcrop
          end

          register_instance_option(:thumb_method) do
            @thumb_method ||= ((versions = bindings[:object].send(name).versions.keys).find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || versions.first.to_s)
          end

          register_instance_option(:delete_method) do
            "remove_#{name}"
          end

          register_instance_option(:cache_method) do
            "#{name}_cache"
          end

          def resource_url(thumb = false)
            return nil unless (uploader = bindings[:object].send(name)).present?
            thumb.present? ? uploader.send(thumb).url : uploader.url
          end
        end
      end
    end
  end
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if properties[:name] == :jcrop
    fields << RailsAdmin::Config::Fields::Types::Jcrop.new(parent, properties[:name], properties)
    true
  else
    false
  end
end


