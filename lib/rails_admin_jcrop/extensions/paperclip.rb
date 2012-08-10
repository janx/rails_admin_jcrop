module Paperclip
  class RailsAdminJcropCropper < Thumbnail
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
