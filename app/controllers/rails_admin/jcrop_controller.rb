module RailsAdmin

  class JcropController < RailsAdmin::ApplicationController
    skip_before_filter :get_model
    before_filter :get_model, :get_object, :get_field

    helper_method :abstract_model, :geometry

    def edit
      respond_to do |format|
        format.html
        format.js   { render :edit, :layout => false }
      end
    end

    def update
      @object.rails_admin_crop! params

      respond_to do |format|
        format.html { redirect_to_on_success }
        format.js do
          asset = @object.send @field
          urls = {:original => asset.url}
          @object.class.uploaders[@field.to_sym].versions.each {|name, _| urls[name] = asset.url(name)}

          render :json => {
            :id    => @object.id,
            :label => @model_config.with(:object => @object).object_label,
            :field => @field,
            :urls  => urls
          }
        end
      end
    end

    private

    def get_field
      @field = params[:field]
    end

    def geometry(image_path)
      image = MiniMagick::Image.open(image_path)
      [image[:width], image[:height]]
    end

    def cropping?
      [:crop_x, :crop_y, :crop_w, :crop_h].all? {|c| params[c].present?}
    end
  end

end
