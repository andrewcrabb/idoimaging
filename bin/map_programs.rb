#! /usr/bin/env ruby

require 'Mysql2'
require_relative '../app/models/resource'
require 'pp'

exit unless Rails.env.eql?("development")
$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select *"
sql += " from program"
sql += " where remdate like '0000-00-00'"
# sql += " and name like 'DCM4CHEE%'"
sql += " and ident >= 100"
sql += " order by ident desc"
# sql += " limit 100"
rslt = $c.query(sql, :symbolize_keys => true)
puts "#{rslt.count} results returned"
rslt.each do |r|
  # pp r
  pname = r[:name]
  p = Program.find_by(name: pname)
  if p
    # puts "name: #{pname} old id #{r[:ident]} new id #{p.id}"
    printf("%3d %3d\n", r[:ident], p.id)
  else
    puts "name: #{pname} not found"
  end

end