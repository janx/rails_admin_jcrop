require "rails_admin_jcrop/detector"
require "rails_admin_jcrop/engine"

module RailsAdminJcrop
  module Orm
    autoload :ActiveRecord, 'rails_admin_jcrop/orm/active_record'
    autoload :Mongoid, 'rails_admin_jcrop/orm/mongoid'
  end
end

require "rails_admin_jcrop/extensions/#{RailsAdminJcrop::Detector.upload_plugin.downcase}"
require 'rails_admin_jcrop/extensions/rails_admin'
