RailsAdmin::Engine.routes.draw do
  controller "main" do
    scope ":model_name" do
      scope "(:id)/:field" do
        get "/jcrop", :to => 'jcrop#edit', :as => :jcrop
        put "/jcrop", :to => 'jcrop#update'
      end
    end
  end
end
