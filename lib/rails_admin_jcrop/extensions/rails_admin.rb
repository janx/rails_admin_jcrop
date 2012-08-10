require "rails_admin_jcrop/detector"
require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/config/fields'
require 'rails_admin/config/fields/types/file_upload'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Jcrop < RailsAdmin::Config::Fields::Types::FileUpload
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:partial) do
            :form_jcrop
          end

          register_instance_option(:jcrop_options) do
            {}
          end

          register_instance_option(:fit_image) do
            @fit_image ||= false
          end

          module CarrierWave
            def self.included(base)
              base.register_instance_option(:cache_method) do
                "#{name}_cache"
              end

              base.register_instance_option(:thumb_method) do
                @thumb_method ||= ((versions = bindings[:object].send(name).versions.keys).find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || versions.first.to_s)
              end

              base.register_instance_option(:delete_method) do
                "remove_#{name}"
              end
            end

            def resource_url(thumb = false)
              return nil unless (uploader = bindings[:object].send(name)).present?
              thumb.present? ? uploader.send(thumb).url : uploader.url
            end
          end

          module Paperclip
            def self.included(base)
              base.register_instance_option(:cache_method) do
                nil
              end

              base.register_instance_option(:thumb_method) do
                @thumb_method ||= ((styles = bindings[:object].send(name).styles.keys).find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || styles.first.to_s)
              end

              base.register_instance_option(:delete_method) do
                nil
              end
            end

            def resource_url(thumb = false)
              return nil unless (attachment = bindings[:object].send(name)).present?
              thumb.present? ? attachment.url(thumb) : attachment.url
            end
          end

          include const_get(RailsAdminJcrop::Detector.upload_plugin)
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
