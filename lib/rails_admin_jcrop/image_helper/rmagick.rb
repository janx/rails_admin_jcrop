module RailsAdminJcrop
  module ImageHelper
    def self.crop(img, w, h, x, y)
      img.crop! x.to_i, y.to_i, w.to_i, h.to_i
    end
  end
end
