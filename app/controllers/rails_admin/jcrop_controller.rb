require 'mini_magick'

module RailsAdmin

  class JcropController < RailsAdmin::ApplicationController
    skip_before_filter :get_model
    before_filter :get_model, :get_object, :get_field, :get_image, :get_fit_image

    helper_method :abstract_model, :geometry

    def edit
      @form_options = {}
      @form_options[:method] = :put
      @form_options[:'data-title'] = "#{I18n.t("admin.actions.crop.menu").capitalize} #{abstract_model.model.human_attribute_name @field}"

      @image_tag_options = {}
      @image_tag_options[:class] = "jcrop-subject"
      @image_tag_options[:'data-geometry'] = geometry.join(",")

      if @fit_image
        fitted_geometry = fit_image_geometry

        @form_options[:'style'] = "margin-left: #{375 - (fitted_geometry[0]/2) - 15}px;"

        @image_tag_options[:style] = ""
        @image_tag_options[:style] << "width: #{fitted_geometry[0]}px !important;"
        @image_tag_options[:style] << "height: #{fitted_geometry[1]}px !important;"
        @image_tag_options[:style] << "border: 1px solid #AAA !important;"
      end

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
          thumbnail_names.each {|name| urls[name] = asset.url(name)}

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

    def thumbnail_names
      RailsAdminJcrop::AssetEngine.thumbnail_names(@object, @field)
    end

    def get_fit_image
      @fit_image = params[:fit_image] == "true" ? true : false
    end

    def get_field
      @field = params[:field]
    end

    def get_image
      @image = MiniMagick::Image.open(@object.send(@field).url)
    end

    def geometry
      [@image[:width], @image[:height]]
    end

    def fit_image_geometry
      # Magic number origin: https://github.com/janx/rails_admin_jcrop/pull/2
      @image.resize "720x400"
      [@image[:width], @image[:height]]
    end

    def cropping?
      [:crop_x, :crop_y, :crop_w, :crop_h].all? {|c| params[c].present?}
    end
  end

end
