#! /usr/bin/env ruby

# Carrierwave-related files used by this program:
#   config/initializers/carrier_wave.rb
#   app/models/image.rb
#   app/uploaders/image_uploader.rb

require 'pp'
require 'Mysql2'
require_relative '../app/models/resource'
require_relative '../app/models/image'

# exit unless Rails.env.eql?("development")

# Program.all.each { |p| p.images.delete_all }
Image.delete_all

INPATH = "/Users/ahc/idoimaging/public_html/img/cap/prog"

def filename(infile)
  m = infile.match(/^prog_(\d+)_([^_]+)_(\d)_(\d+)_(\d+)\.(.+)$/)
  # <MatchData "prog_102_emma_0_560_420.jpg" 1:"102" 2:"emma" 3:"0" 4:"560" 5:"420" 6:"jpg">
  m ? sprintf("%s_%s.%s",  m[2], m[3], m[6]) : 'program.jpg'
end

$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select image.filename, image.rsrcid, image.filename, program.name as `program_name`"
sql += " from image, program"
sql += " where image.scale = 'full'"
sql += " and image.rsrcfld = 'prog'"
sql += " and image.rsrcid = program.ident"
sql += " and program.remdate like '0000%'"
# sql += " limit 3"
images = $c.query(sql, :symbolize_keys => true)

puts "#{images.count} images returned"
images.each do |r|
  newname = filename(r[:filename])
  puts "Program: #{r[:program_name]}, image #{r[:filename]}, new name #{newname}"
  imgs = Image.where(image: newname)

  if (imgs.count > 0)
    puts "Skipping image #{r[:filename]}: Already present as #{newname}"
    next
  end

  prog = Program.find_by(name: r[:program_name])
  unless prog
    puts "ERROR: prog #{r[:program_name]}"
    next
  end
  i = Image.new
  fullfile = "#{INPATH}/#{r[:filename]}"
  puts "fullfile #{fullfile}"
  File.open(fullfile) do |f|
    i.image = f
  end
  i.save!
  prog.images << i

  puts "program #{prog.id} added #{i.image}, now #{prog.images.count} images after adding image #{i.id} file #{fullfile}"
end
