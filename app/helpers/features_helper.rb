module FeaturesHelper

  # Return Feature object for this category and value, or its id
  #
  # return_full: Return object if true, else object id

  def feature_query(category, value, return_full = false)
    feats = Feature.where(category: category, value: value)
    feat = (feats.count.eql? 1) ? feats.first : nil
    return feat ? (return_full ? feat : feat.id) : feat
  end
end