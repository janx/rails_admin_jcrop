# RailsAdmin Jcrop Plugin

## Image cropping made easy! ##

1. Add it to your Gemfile and run `bundle install`:

```ruby
gem 'rails_admin'
# Because rails_admin_jcrop autoload modules by checking plugins you use, it's
# recommended to require it explictly before rails_admin_jcrop
# e.g. if you use carrierwave
# gem 'carrierwave'
# or
# gem 'paperclip'
gem 'rails_admin_jcrop' #, git: 'git://github.com/janx/rails_admin_jcrop.git'
```

2. Configure your model field to use Jcrop:

```ruby
# RAILS_ROOT/config/initializers/rails_admin.rb
config.model User do
  configure :avatar, :jcrop

  # Below is optional
  edit do
    field :avatar do
      jcrop_options aspectRatio: 500.0/320.0
    end
  end
end
```

3. If you use Paperclip, you need to do nothing here, rails_admin_jcrop will append RailsAdminJcropper processor to your attachment automatically. If CarrierWave is used, please invoke  :rails_admin_crop in your uploader:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base

  version :thumb do
    process :rails_admin_crop
    process resize_to_fill: [500,320]
  end

end
```

4. Done! Click the image on your RailsAdmin model edit page and enjoy cropping!
![Cropping Screenshot](https://github.com/janx/rails_admin_jcrop/raw/master/screenshots/example.png)

### Tips ###

* Crop is done when you successfully return from the modal box, you don't need to save the whole record.
* If you don't see the cropped image on rails admin edit page, the browser is possibly displaying cached version. Try refresh your browser.
* `rails_admin_jcrop >= 1.0.0` works with `rails_admin ~> 0.3.x`. For older rails_admin, use rails_admin_jcrop 0.2.1.

## Field Options ##

### jcrop_options ###

You can pass any Jcrop plugin allowed options here, for example, use `aspectRatio` to fix the ratio of selection box:

```ruby
field :avatar do
  jcrop_options aspectRatio: 500.0/320.0
end
```

Please check [Jcrop document](http://deepliquid.com/content/Jcrop_Manual.html#Setting_Options) for more available options.

### fit_image ###

By default, image is scaled properly to make cropping more easy, but sometimes the image is still too large to fit in the modal window, you may need to scroll image up/down to crop. If you set `fit_image` to true, image will always be resized to fit in modal window.

```ruby
field :avatar do
  fit_image true
end
```

Check screenshots below to see the difference:

When `fit_image` is false (default)

![fit_image false](https://github.com/janx/rails_admin_jcrop/raw/master/screenshots/fit_image_false.png)

When `fit_image` is true

![fit_image true](https://github.com/janx/rails_admin_jcrop/raw/master/screenshots/fit_image_true.png)

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
* MiniMagick

## Supported ORM ##

* ActiveRecord
* Mongoid

## Supported Asset Plugin ##

* CarrierWave
* Paperclip

## TODO ##

* make sure rails_admin_jcrop load after paperclip/carrierwave load
* automate :rails_admin_crop for CarrierWave uploader

## Contributing ##

Any help is encouraged. Here are some ways you can contribute:

* by using it
* by telling people
* by reporting bugs or suggesting new features on github issue tracker
* by fixing bugs or implementing features

## Thanks ##

### Contributors ###

* [Alan Rosin Sikora](https://github.com/alansikora) ([alansikora](https://github.com/alansikora))
* [cec](https://github.com/cec)
* [Alex Chien](https://github.com/AlexChien)
* [Mitsuhiro Shibuya](https://github.com/mshibuya)
* [anant anil kolvankar](https://github.com/anantkolvankar)

### And ... ###

Life is easier with you.

* [RailsAdmin](https://github.com/sferik/rails_admin/)
* [Jcrop](http://deepliquid.com/content/Jcrop.html)
