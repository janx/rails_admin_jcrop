# RailsAdmin Jcrop Plugin

## Image cropping made easy! ##

1. Add it to your Gemfile and run `bundle install`:

    gem 'rails_admin'
    gem 'rails_admin_jcrop'

2. Configure your model field to use Jcrop:

    # RAILS_ROOT/config/initializers/rails_admin.rb
    config.model User do
      configure :avatar, :jcrop

      # Below is optional
      edit do
        field :avatar do
          # use jcrop_options to pass any options you like to .Jcrop call in javascript
          jcrop_options aspectRatio: 500.0/320.0
        end
      end
    end

3. Include a module in your Carrierwave models:

    class User < ActiveRecord::Base
       mount_uploader :avatar, AvatarUploader
       include RailsAdminJcrop::ActiveRecordMixin # make sure you include the mixin after all mount_uploader declarations
    end

4. Done! Click the image on your RailsAdmin model edit page and enjoy cropping!

![Cropping Screenshot](screenshot.png)

## TODO ##

* Automatically include model mixin
* MongoDB support
* Paperclip support
* RMagick support

## Thanks ##

Life is easier with you.

* [RailsAdmin](https://github.com/sferik/rails_admin/)
* [Jcrop](http://deepliquid.com/content/Jcrop.html)
