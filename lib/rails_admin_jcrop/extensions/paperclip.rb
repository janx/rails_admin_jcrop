module RailsAdminJcrop
  module Extensions
    module Paperclip
      class <<self
        def thumbnail_names(obj, field)
          obj.send(field).styles.keys
        end
      end
    end
  end
end

module Paperclip

  module NewClassMethods
    def has_attached_file(*args)
      super

      self.attachment_definitions.each do |name, options|
        options[:processors] ||= []
        options[:processors] << :rails_admin_jcropper
      end
    end
  end

  module ClassMethods
    def self.extended(base)
      super
      base.send :extend, ::Paperclip::NewClassMethods
    end
  end

  class RailsAdminJcropper < Thumbnail
    def transformation_command
      if @attachment.instance.rails_admin_cropping?
        ary = super
        if i = ary.index('-crop')
          ary.delete_at i
          ary.delete_at i+1
        end
        ['-crop', crop_params] + ary
      else
        super
      end
    end

    def crop_params
      target = @attachment.instance
      "'#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
    end
  end

end
