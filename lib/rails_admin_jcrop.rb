require "rails_admin_jcrop/engine"

module RailsAdminJcrop
end

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Jcrop < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)
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


