module FeaturesHelper

  # Return Feature object for this category and value, or its id
  #
  # return_full: Return object if true, else object id

  def feature_query(category, value, return_full = false)
    feats = Feature.where(category: category, value: value)
    feat = (feats.count.eql? 1) ? feats.first : nil
    return (feat and not return_full) ? feat.id : feat
  end

  # Return ImageFormat object for this name, or its id
  #
  # return_full: Return object if true, else object id

  def image_format_query(name, return_full = false)
    imgs = ImageFormat.where(name: name)
    img = (imgs.count.eql? 1) ? imgs.first : nil
    return (img and not return_full) ? img.id : img
  end


end