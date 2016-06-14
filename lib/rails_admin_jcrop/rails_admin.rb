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
            @fit_image ||= true
          end

          include ::RailsAdmin::Config::Fields::Types::UploaderMethods
        end
      end
    end
  end
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if (properties.respond_to?(:name) ? properties.name : properties[:name]) == :jcrop
    fields << RailsAdmin::Config::Fields::Types::Jcrop.new(parent, :jcrop, properties)
    true
  else
    false
  end
end
