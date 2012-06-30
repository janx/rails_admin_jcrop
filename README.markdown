# RailsAdmin Jcrop Plugin

## Image cropping made easy! ##

1. Add it to your Gemfile and run `bundle install`:

        gem 'rails_admin'
        gem 'rails_admin_jcrop' #, git: 'git://github.com/janx/rails_admin_jcrop.git'

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

3. Done! Click the image on your RailsAdmin model edit page and enjoy cropping!
![Cropping Screenshot](https://github.com/janx/rails_admin_jcrop/raw/master/screenshot.png)

## Localization ##

Localize the crop form by adding these entries:

        zh:
          admin:
            actions:
              crop:
                title: '剪裁'
                menu: '剪裁'

## Dependencies ##

* MRI 1.9.3 (All above 1.8.6 should work, I only tested on 1.9.3)
* Rails 3.x
* ORM
    - ActiveRecord
* Upload plugin
    - CarrierWave
* Image processor
    - MiniMagick

## TODO ##

* MongoDB support
* Paperclip support
* RMagick support

## Contributing ##

Any help is encouraged. Here are some ways you can contribute:

* by using it
* by telling people this plugin
* by reporting bugs or suggesting new features on github issue tracker
* by fixing bugs or implementing features
* by giving author a hug (especially if you're girl)

## Thanks ##

Life is easier with you.

* [RailsAdmin](https://github.com/sferik/rails_admin/)
* [Jcrop](http://deepliquid.com/content/Jcrop.html)
