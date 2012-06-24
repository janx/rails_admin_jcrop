module RailsAdmin

  class JcropController < RailsAdmin::ApplicationController
    skip_before_filter :get_model
    before_filter :get_model, :get_object, :get_field

    helper_method :abstract_model

    def edit
      respond_to do |format|
        format.html
        format.js   { render :edit, :layout => false }
      end
    end

    def update
      respond_to do |format|
        format.html { redirect_to_on_success }
        format.js { render :json => { :id => @object.id, :label => @model_config.with(:object => @object).object_label } }
      end
    end

    private

    def get_field
      @field = params[:field]
    end
  end

end
