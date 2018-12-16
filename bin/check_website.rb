#! /usr/bin/env ruby

# Check revision string for all sites having 
# Program.joins(:resources).where(resources: {resourceful_type: 'Program', resource_type: 4}).count

Program.first(10).each do |program|
  rev_urls = program.rev_urls
  next unless rev_urls.count.nonzero?
  rev_url = rev_urls.first
  
end