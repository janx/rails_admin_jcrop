require 'mini_magick'

module RailsAdmin

  class JcropController < RailsAdmin::ApplicationController
    skip_before_filter :get_model
    before_filter :get_model, :get_object, :get_field, :get_fit_image

    helper_method :abstract_model, :geometry

    # These numbers are based on bootstrap defaults
    # https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_variables.scss
    # width: $modal-lg(900px) - 2 * border(1px) - 2 * $modal-inner-padding(15px)
    # height: width * 9/16 (16:9 format)
    FIT_IMAGE_DIMENSIONS = [868, 489]

    def edit
      @form_options = {}
      @form_options[:method] = :put
      @form_options[:'data-title'] = "#{I18n.t("admin.actions.crop.menu").capitalize} #{abstract_model.model.human_attribute_name @field}"

      @image_tag_options = {}
      @image_tag_options[:class] = "jcrop-subject"
      @file_path=''
      #Condition for Carrierwave.
      if @object.send(@field).class.to_s =~ /Uploader/

        if @object.send(@field)._storage.to_s =~ /Fog|AWS/ ||
           @object.send(@field)._storage.to_s =~ /SFTP/ ||
           @object.send(@field)._storage.to_s =~ /FTP/

          @file_path=@object.send(@field).url
        else

          @file_path=@object.send(@field).path
        end
      #Condition for Paperclip.
      elsif @object.send(@field).class.to_s =~ /Paperclip/

        if (@object.send(@field).options[:storage].to_s =='s3')

          @file_path=@object.send(@field).url
        else

          @file_path=@object.send(@field).path
        end
      end

      @image_tag_options[:'data-geometry'] = geometry(@file_path).join(",")

      @form_options[:'style'] = 'overflow: auto;'

      if @fit_image_geometry
        fit_image_geometry = fit_image_geometry(@file_path)

        @form_options[:'style'] << "margin-left: #{(FIT_IMAGE_DIMENSIONS[0] - fit_image_geometry[0])/2}px;"

        @image_tag_options[:style] = ""
        @image_tag_options[:style] << "width: #{fit_image_geometry[0]}px !important;"
        @image_tag_options[:style] << "height: #{fit_image_geometry[1]}px !important;"
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
      @fit_image_geometry = params[:fit_image] == "true" ? true : false
    end

    def get_field
      @field = params[:field]
    end

    def geometry(image_path)
      image = MiniMagick::Image.open(image_path)
      [image[:width], image[:height]]
    end

    def fit_image_geometry(image_path)
      image = MiniMagick::Image.open(image_path)
      image.resize FIT_IMAGE_DIMENSIONS.join('x')
      [image[:width], image[:height]]
    end

    def cropping?
      [:crop_x, :crop_y, :crop_w, :crop_h].all? {|c| params[c].present?}
    end
  end

end
