module RailsAdminJcrop
  module ImageHelper
    def self.crop(img, w, h, x, y)
      geometry = "#{w}x#{h}+#{x}+#{y}"
      img.crop geometry
    end
  end
end
