#! /usr/bin/env ruby

require 'pp'
require 'Mysql2'
require_relative '../app/models/resource'
require_relative '../app/models/image'

exit unless Rails.env.eql?("development")

Version.delete_all
$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')
sql = "select version.version, version.reldate, version.adddate, program.name as `program_name`"
sql += " from version, program"
sql += " where version.progid = program.ident"
sql += " and program.remdate like '0000%'"
sql += " and version.reldate not like '2000-00-00'"
# sql += " order by adddate desc"
sql += " order by program.name"
# sql += " limit 3"
versions = $c.query(sql, :symbolize_keys => true)

# Create all Versions and associate with their Program

puts "#{versions.count} versions returned"
versions.each do |v|
  puts "Program: #{v[:program_name]}, version #{v[:version]} reldate #{v[:reldate]} added #{v[:adddate]}"
  prog = Program.find_by(name: v[:program_name])
  unless prog
    STDERR.puts "ERROR: prog #{v[:program_name]}"
    next
  end
  vparams = {
    version: v[:version],
    date:    v[:reldate],
  }
  puts "Creating Version: #{vparams}"
  ver = Version.create(vparams)
  prog.versions << ver
end

# Add the revision string to the most recent version
sql = "select name, revstr from program"
sql += " where program.ident >= 100"
sql += " and length(revstr) > 0"
sql += " order by program.name"
# sql += " limit 3"
revstrs = $c.query(sql, :symbolize_keys => true)

revstrs.each do |r|
  # puts "Program #{r[:name]} revstr #{r[:revstr]}"
  prog = Program.find_by(name: r[:name])
  unless prog
    STDERR.puts "ERROR: prog #{r[:name]}"
    next
  end
  lastver = prog.versions.order(:date).last
  next unless lastver
  lastver.rev_str = r[:revstr]
  lastver.save
  puts "Adding rev_str #{r[:revstr]} to version #{lastver.id} for #{prog.name}"
end
