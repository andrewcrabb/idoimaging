class Rating < ActiveRecord::Base
  belongs_to :program
  belongs_to :user

  # Admin has several types of ratings
  # rating_type => weight
  RATING_TYPES = {
    overall: 35,
    breadth: 25,
    scale: 25,
    website: 10,
    appearance: 5
  }

  scope :rating_type, ->(rating_type){ where(rating_type: rating_type) }
  scope :user       , ->(id)         { where(user_id: id)}
  scope :rating_of  , ->(p_id, u_id) { where(program_id: p_id, user_id: u_id) }

  scope :appearance , -> { where(rating_type: 'appearance')}
  scope :breadth    , -> { where(rating_type: 'breadth'   )}
  scope :overall    , -> { where(rating_type: 'overall'   )}
  scope :scale      , -> { where(rating_type: 'scale'     )}
  scope :website    , -> { where(rating_type: 'website'   )}

  scope :admin , -> { where.not(rating_type: 'user')  }

end
