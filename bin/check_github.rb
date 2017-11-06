#! /usr/bin/env ruby

require 'octokit'
require 'pp'

exit unless Rails.env.eql?("development")

revurl = ResourceType.find_by(name: ResourceType::REV_URL)
revurl_id = revurl.id

prog = Program.find_by(name: 'pydicom')
puts "Prog: #{prog.id}"
prog_revs = prog.resources
last_version_rec = prog.versions.order(:date).first
last_version = last_version_rec.version

puts "last_version #{last_version}"

user = Octokit.user 'pydicom'
puts "user: #{user.first}"
