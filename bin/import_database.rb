#! /usr/bin/env ruby

require 'Mysql2'
require_relative '../app/models/resource'

exit unless Rails.env.eql?("development")

FUNCTIONS = {
  1  => 'Utility',
  2  => 'Display',
  3  => 'Write',
  4  => 'Convert',
  5  => 'Transfer',
  6  => 'Register',
  7  => 'Language',
  8  => 'Server',
  9  => 'Library',
  10 => 'Modelling',
}

FORMATS = {
  1  => 'DICOM',
  2  => 'NEMA',
  3  => 'Analyze',
  4  => 'GE Scanditronix',
  5  => 'GE MRI-4',
  6  => 'GE MRI-5',
  7  => 'GE MRI-LX',
  8  => 'Interfile',
  9  => 'ECAT 6',
  10 => 'ECAT 7',
  11 => 'Picker CT',
  12 => 'Siemens',
  13 => 'Minc',
  14 => 'Raw',
  15 => 'Gif',
  16 => 'JPEG',
  17 => 'TIFF',
  18 => 'PNG',
  19 => 'BMP',
  21 => 'Matlab',
  22 => 'PPM',
  23 => 'PGM',
  24 => 'Papyrus',
  25 => 'ADVANCE',
  26 => 'SPM',
  27 => 'Bruker',
  28 => 'QuickTime',
  29 => 'PICT',
  30 => 'VTK',
  31 => 'AFNI',
  32 => 'Own/Unique',
  33 => 'LONI',
  34 => 'NIFTI',
  35 => 'NetCDF',
  36 => 'GIPL',
  37 => 'MGH',
  38 => 'NRRD',
  39 => 'GIFTI',
  40 => 'MGH',
}

WriteProgramImageFormat.delete_all
ReadProgramImageFormat.delete_all
# ProgramImageFormat.delete_all
ProgramFeature.delete_all
AuthorProgram.delete_all
ImageFormat.delete_all
Resource.delete_all
Rating.delete_all
Program.delete_all
Feature.delete_all
Author.delete_all

# Hack to avoid id = 1 which Ransack cannot handle (see my wiki).
# This only needs to be done on searchable fields (ie not Program).
ImageFormat.create!
ImageFormat.last.delete
Resource.create!(url: 'FALSE')
Resource.last.delete
Feature.create!
Feature.last.delete

def make_resource(resource_type_name, url)
  if (url and url.length > 0)
    puts "Creating resource: #{resource_type}, #{url}"
    resource_type = ResourceType.find_by(name: resource_type_name)
    r = Resource.find_or_create_by(
      resource_type: resource_type,
      url:           url
    )
  end
end

def find_auth(id)
  sql  = "select *"
  sql += " from author"
  sql += " where ident = '#{id}'"
  rslt = $c.query(sql, :symbolize_keys => true)
  a = nil
  rslt.each do |r|
    puts "Creating author: #{r[:name_last]} (#{r[:home]}) (initially #{Author.all.count}) "
    a = Author.find_or_create_by(
      name_last:   r[:name_last],
      name_first:  r[:name_first],
      institution: r[:institution],
      country:     r[:country],
    )
    if r[:home] and r[:home].length > 0
      homeurl = make_resource('home_url', r[:home])
      a.resources << homeurl
    end
    a.save!
  end
  # puts "find_auth (now #{Author.count}) returning: #{a}"
  return a
end

def make_image_format(name, value, functionality)
  # puts "make_feature(#{name}, #{value}): #{f.id}: now #{Feature.count} features"
  f
end

def make_feature(category, value)
  # puts "make_feature(#{category}, #{value})"
  case category
  when 'Platform'
    value = PLATFORMS[value.to_i] if value
    # puts "platform value #{value}"
  when 'Language'
    value = LANGUAGES[value.to_i] if value
    # puts "language value #{value}"
  when 'Function'
    value = FUNCTIONS[value.to_i] if value
  when 'Interface'
    value = INTERFACES[value.to_i] if value
  end
  # f = Object.const_get("Feature#{category}").find_or_create_by(value: value)
  f = Feature.find_or_create_by(category: category, value: value)
  puts "make_feature(#{category}, #{value}): #{f.id}: now #{Feature.count} features"
  f
end

def decode_feature(name, value)
  feats = []
  arr = value.to_i.to_s(2).split('')
  arr.each_with_index do |c, i|
    if c.eql?('1')
      feats << make_feature(name, arr.length - i - 1)
    end
  end
  feats
end

def decode_image_format(value)
  # puts "decode_image_format(#{value})"
  image_formats = []
  arr = value.to_i.to_s(2).split('')
  arr.each_with_index do |c, i|
    if c.eql?('1')
      format_index = arr.length - i - 1
      format_name = FORMATS[format_index.to_i]
      # puts "index #{format_index}, name #{format_name}"
      if format_name
        image_formats << ImageFormat.find_or_create_by(name: format_name)
      end
    end
  end
  puts "decode_image_format(#{value}) returning #{image_formats.map { |i| i.name }}"
  image_formats
end

# Nasty bug in Ransack loses arg values 0 or 1 when used in a scope.  See seeds.rb

# $c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'client', database: 'imaging')
$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select *"
sql += " from program"
sql += " where remdate like '0000-00-00'"
# sql += " and name like 'DCM4CHEE%'"
sql += " and ident >= 100"
sql += " order by ident desc"
# sql += " limit 30"
rslt = $c.query(sql, :symbolize_keys => true)
puts "#{rslt.count} results returned"
rslt.each do |r|
  p = Program.new(
    name:        r[:name],
    summary:     r[:summ],
    description: r[:descr],
    add_date:    r[:adddate],
  )
  pname = p.name
  if authors = find_auth(r[:auth])
    p.authors << authors
  else
    puts "ERROR: No authors for program #{r[:name]}"
    next
  end
  # p.features << decode_feature('Platform', r[:plat])
  # p.features << decode_feature('Language', r[:lang])
  # p.features << decode_feature('Function', r[:func])
  # p.features << decode_feature('Interface', r[:interface])

  (rsrc = make_resource(Resource::SOURCE_URL, r[:counturl])) && p.resources << rsrc
  (rsrc = make_resource(Resource::HOME_URL  , r[:revurl]))   && p.resources << rsrc
  (rsrc = make_resource(Resource::REV_URL   , r[:homeurl]))  && p.resources << rsrc
  (rsrc = make_resource(Resource::COUNT_URL , r[:srcurl]))   && p.resources << rsrc
  p.save!
  # Read formats
  read_formats = decode_image_format(r[:readfmt])
  puts "read_formats for #{p.name}: #{read_formats.map { |f| f.name } }"
  read_formats.each do |fmt|
    # p.program_image_formats.create(image_format: fmt, functionality: 'read')
    p.read_program_image_formats.create(image_format: fmt)
  end
  # Write formats
  write_formats = decode_image_format(r[:writfmt])
  puts "write_formats for #{p.name}: #{write_formats.map { |f| f.name } }"
  write_formats.each do |fmt|
    # p.program_image_formats.create(image_format: fmt, functionality: 'write')
    p.write_program_image_formats.create(image_format: fmt)
  end
  # Interfaces
  # interfaces = decode_interface(r[:interface])
  # puts "interfaces for #{p.name}: #{interfaces.map { |f| f.name } }"
  # interfaces.each do |interface|
  #   p.program_image_formats.create(image_format: fmt, functionality: 'write')
  # end

  pp = Program.find_by(name: pname)
  puts "There are #{ProgramFeature.count} ProgramFeatures"
  puts "There are #{Feature.count} Features: #{Feature.all.pluck(:value)}"
  puts "pp (#{pp.name}) has #{pp.features.count} features: #{pp.features.pluck(:value)}"
end
puts "#{Program.count} programs"
