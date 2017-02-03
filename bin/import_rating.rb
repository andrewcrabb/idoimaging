#! /usr/bin/env ruby

# select rank_activity, rank_appear, rank_doc, rank_scope, rank_overall
# from program
# where remdate like '0000%'
# and rank_overall > 0

# Mapping old to new database fields
# rank_activity         : Calculate from versions
# rank_doc              : website
# rank_appear           : appearance
# rank_scope            : breadth
# rank_overall          : overall

require 'pp'
require 'Mysql2'
require_relative '../app/models/rating'

exit unless Rails.env.eql?("development")

Rating.delete_all
$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select name, rank_appear, rank_doc, rank_scope, rank_overall"
sql += " from program"
sql += " where program.remdate like '0000%'"
sql += " and program.rank_overall > 0"
sql += " order by program.name"
# sql += " limit 10"
programs = $c.query(sql, :symbolize_keys => true)

puts "#{programs.count} programs returned"
user = User.find_by(email: 'admin@idoimaging.com')
unless user
  STDERR.puts "ERROR: no user"
  exit
end
programs.each do |p|
  name = p[:name]
  ratings = {
    overall:    p[:rank_overall],
    breadth:    p[:rank_scope],
    scale:      0,
    website:    p[:rank_doc],
    appearance: p[:rank_appear],
  }
  puts "#{name}: #{ratings}"
  prog = Program.find_by(name: name)
  unless prog
    STDERR.puts "ERROR: prog #{name}"
    next
  end
  ratings.each do |rating_type, rating_value|
    params = {
      rating: rating_value,
      user_id: user.id,
      # rating_type: rating_type,
    }
    puts "params: #{params}"
    prog.send("create_#{rating_type}_rating", params)
  end
end
