#! /usr/bin/env ruby

# Useful query: Retrieve all versions that have been tested and either have a nil seen date or a seen date older than tested date
# tested_versions = Version.where.not(last_tested: nil)
# tested_versions.where(last_seen: nil).or(Version.where("last_seen < last_tested"))

require 'httparty'
# include HTTParty
# Check revision string for all sites having 
# Program.joins(:resources).where(resources: {resourceful_type: 'Program', resource_type: 4}).count

# Program.joins(:versions).where.not(versions: {rev_str: nil}).group(:id).map{ |p| p.versions.map{ |v| v.rev_str }.join(',') }
# Program.where.not(rev_str: nil).first(10).each do |program|
# programs = Program.joins(:versions).where.not(versions: {rev_str: nil}).group(:id)
Program.non_githubs.each do |program|
  rev_urls = program.rev_urls
  unless rev_urls.count.nonzero?
    # puts "Error: Program #{program.id} #{program.name} has no rev_urls"
    printf("Program %3d %-40s no rev_url\n", program.id, program.name)
    next
  end
  src_url = program.source_urls.count.zero? ? nil : program.source_urls.first
  rev_url = rev_urls.first
  if rev_url.github? or (src_url and src_url.github?)
    printf("Program %3d %-40s github\n", program.id, program.name)
    next
  end

  ver = program.versions.order(:date).last
  unless ver and ver.rev_str
    printf("Program %3d %-40s no rev_str\n", program.id, program.name)
    next
  end

  response = HTTParty.get(rev_url.full_url)
  got_response = response.code.eql?(200) && response.body
  foundit = got_response ? response.body.include?(ver.rev_str) : false

  ver.last_tested = Date.today
  ver.last_seen = Date.today if foundit
  ver.save

  # puts "Program #{program.id} #{program.name} rev_url #{rev_url} last version #{ver.version} date #{ver.date} rev_str #{ver.rev_str} "
  printf("Program %3d %-40s last version %15s date %12s rev_str %22s found %s in %6d rev_url %s\n", program.id, program.name, ver.version, ver.date, ver.rev_str, foundit.to_s, response.body.length, rev_url.url)
end
