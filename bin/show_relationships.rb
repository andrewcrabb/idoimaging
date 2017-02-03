#! /usr/bin/env ruby

# Note you need to extend this to use Program::prer as well.

require 'Mysql2'
require 'pp'
exit unless Rails.env.eql?("development")

# Return true if added, else false.

def addit(related, p1, p2)
  # puts "p1 #{p1} p2 #{p2}"
  add = (related.has_key?(p1) and related[p1].include? p2) ? false : true
  related[p1] << p2 if add
  add
end

$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select related.prog1, related.prog2, program.name"
sql += " from related, program"
sql += " where related.prog1 = program.ident"
sql += " order by program.name"
# sql += " limit 10"
rslt = $c.query(sql, :symbolize_keys => true)
puts "#{rslt.count} results returned"
related = Hash.new{ |h,k| h[k] = [] }
rslt.each do |r|
  p1 = r[:prog1]
  p2 = r[:prog2]
  addit(related, p2, p1) unless addit(related, p1, p2)
end
# pp related
puts "#{related.keys.count} keys"

psql = "select ident, name from program"
prslt = $c.query(psql, :symbolize_keys => true)
id_to_name = {}
prslt.each { |r| id_to_name[r[:ident]] = r[:name]  }
# pp id_to_name

related.each do |key, arr|
  puts "#{id_to_name[key]}: #{arr.map { |e| id_to_name[e]}.join(', ') }"
end
