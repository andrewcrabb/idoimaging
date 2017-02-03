#! /usr/bin/env ruby

# For making program features.
# Assume platform, language, interface done by import_database.db

require 'Mysql2'
# require_relative '../app/models/resource'

exit unless Rails.env.eql?("development")

# Maps old numeric code to [old name, [new category 1, new value 1]<, [new category 2, new value 2]>]
# Empty means no direct mapping of old DB to new

# Sub-features have a category value the same as the value of their category
# ie: [Function: 'Display'], [DisplayFunction: 'Volume rendering']

FUNCTIONS = {
  1  => [] ,  # Utility
  2  => [['Function'        , 'Display'            ]],  # Display
  3  => []   ,  # Write
  4  => [['Function'        , 'Convert'            ]],  # Convert
  5  => [['Function'        , 'Networking'         ]], # Transfer
  6  => [['Function'        , 'Other functions' ], ['OtherFunction', 'Co-registration']],  # Register
  7  => [], # Language
  8  => [['Function'        , 'Networking'         ]], # Server
  9  => [['Programming'    , 'API/Library'        ]], # Library
  10 => [['Function'        , 'Other functions' ], ['OtherFunction', 'Modelling']], # Modelling
}

CATEGORIES = {
  1  => [['Speciality'       , 'MRI'                ]],  # MRI
  2  => [['Speciality'       , 'FMRI'               ]], # FMRI
  3  => [['Speciality'       , 'CT'                 ]], # CT
  4  => [['Speciality'       , 'Ultrasound'         ]], # USound
  5  => [['Speciality'       , 'PET'                ]],  # PET
  6  => [['Speciality'       , 'SPECT'              ]],  # SPECT
  7  => [['Speciality'       , 'Neuro'              ]],  # Neuro
  8  => [['Speciality'       , 'Cardiac'            ]],  # Cardiac
  9  => [['Function'         , 'Other functions' ], ['OtherFunction', 'Modelling'      ]], # Model
  10 => [['Function'         , 'Other functions' ], ['OtherFunction', 'Co-registration']],  # Register
  11 => [['Function'         , 'Other functions' ], ['OtherFunction', 'Segmentation'   ]], # Segment
  12 => [] , # Param
  13 => [['Function'         , 'Display'            ], ['DisplayFunction' , 'Volume rendering']], # Surf/Vol
  14 => [['Speciality'       , 'MEG'                ]], # MEG
  15 => [['Function'         , 'Networking'         ]], # PACS
  16 => [['Speciality'       , 'DTI'                ]],  # DTI
}

FEATURES = {
  1 => [['Function', 'Other functions']  , ['OtherFunction'  , 'Co-registration']],   # Image Fusion
  2 => [],  # Color Maps
  3 => [['Function', 'Other functions']  , ['OtherFunction'  , 'Segmentation'   ]],   # Thresholding
  4 => [['Function', 'Other functions']  , ['OtherFunction'  , 'ROI'            ]],   # ROIs
  5 => [], # DICOM
  6 => [], # Filters
  6 => [],  # MPEG
  7 => [['Function', 'Display']             , ['DisplayFunction'    , 'Volume rendering']], # Volume Render
  8 => [['Function', 'Other functions']  , ['OtherFunction'   , 'Co-registration' ]], # Registration
  9 => [['Function', 'Software development'], ['DevelopmentFunction', 'API/Library'     ]], # API/Toolkit
}

INSTALLERS = {
  0 => [['Distribution', 'Manual build'    ]],  # Manual building and installation
  1 => [['Distribution', 'Ready to run'    ]],  # Ready to run, no installer
  3 => [['Distribution', 'Native installer']],  # Full installer
}

AUDIENCES = {
  0 => [['Audience', 'General user' ]],  # General user
  1 => [['Audience', 'Other user']],  # Other user
  2 => [['Audience', 'Programmer'   ]],  # Programmer
}

INTERFACES = {
  1 => [['Interface', 'API'          ]],
  2 => [['Interface', 'Command Line' ]],
  3 => [['Interface', 'GUI'          ]],
}

LANGUAGES = {
  1   => [['Language', 'C']],
  2   => [['Language', 'C++']],
  3   => [['Language', 'Perl']],
  4   => [['Language', 'TCL']],
  5   => [['Language', 'Java']],
  6   => [['Language', 'Shell']],
  7   => [['Language', 'Matlab']],
  8   => [['Language', 'Delphi']],
  9   => [['Language', 'IDL']],
  10  => [['Language', 'C#']],
  11  => [['Language', 'Python']],
  12  => [['Language', 'Ruby']],
  13  => [['Language', 'PHP']],
  14  => [['Language', 'JavaScript']],
  15  => [['Language', 'R']],
  16  => [['Language', 'Lua']],
  17  => [['Language', 'Julia']],
}

PLATFORMS = {
  0 => [['Platform', 'Windows']],
  1 => [['Platform', 'Mac'    ]],
  2 => [['Platform', 'Linux'  ]],
  3 => [['Platform', 'Virtual']],
  4 => [['Platform', 'Mobile' ]],
}


def make_features(category, value)
  puts "make_features(#{category}, #{value})"
  case category
  when 'Function'
    val = FUNCTIONS[value.to_i] if value
  when 'Category'
    val = CATEGORIES[value.to_i] if value
  when 'Installer'
    val = INSTALLERS[value.to_i] if value
  when 'Audience'
    val = AUDIENCES[value.to_i] if value
  when 'Platform'
    val = PLATFORMS[value.to_i] if value
  when 'Language'
    val = LANGUAGES[value.to_i] if value
  when 'Interface'
    val = INTERFACES[value.to_i] if value
  end
  feats = val.map { |arr| Feature.find_or_create_by(category: arr[0], value: arr[1]) }
  return feats
end

# value is a sum of binary powers encoding index values
# eg: 11 = 1011, encoding 3, 1, 0.

def decode_feature(p, category, value)
  puts "----------  decode_feature(#{p}, #{category}, #{value})  --------------"
  feats = []
  arr = value.to_i.to_s(2).split('')
  arr.each_with_index do |c, i|
    if c.eql?('1')
      feats_this_time = make_features(category, arr.length - i - 1)
      # puts "c #{c} i #{i} feats_this_time #{feats_this_time}"
      feats_this_time.each do |f|
        # puts "f #{f}"
        if (f and p.features.find_by(category: f.category, value: f.value).nil?)
          feats << f
          puts "Adding feature: #{f.value}, now #{feats.count} feats"
        else
          puts "Omitting feature: #{f ? f.value : 'nil'}"
        end
      end
    end
  end
  puts "decode_feature returning #{feats.count} feats"
  feats
end

$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select *"
sql += " from program"
sql += " where remdate like '0000-00-00'"
sql += " and ident >= 100"
sql += " order by ident desc"
# sql += " limit 10"

rslt = $c.query(sql, :symbolize_keys => true)
puts "#{rslt.count} results returned"
rslt.each do |r|
  p = Program.find_by(name: r[:name])
  next if p.nil?
  feats = decode_feature(p, 'Function', r[:func])
  p.features << feats
  feats = decode_feature(p, 'Category', r[:category])
  p.features << feats
  feats = decode_feature(p, 'Installer', r[:installer])
  p.features << feats
  feats = decode_feature(p, 'Audience', r[:audience])
  p.features << feats

  p.features << decode_feature(p, 'Platform', r[:plat])
  p.features << decode_feature(p, 'Language', r[:lang])
  p.features << decode_feature(p, 'Interface', r[:interface])
  p.save
end

# Now do: category, feature, installer, obtain, audience
# Then do: rank_activity, rank_appear, rank_doc, rank_scope, rank_overall
