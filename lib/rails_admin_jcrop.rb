require "rails_admin_jcrop/engine"

module RailsAdminJcrop
  module Orm
    autoload :ActiveRecord, 'rails_admin_jcrop/orm/active_record'
  end
end

require 'rails_admin_jcrop/extensions/carrierwave'
require 'rails_admin_jcrop/extensions/rails_admin'
