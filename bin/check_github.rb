#! /usr/bin/env ruby

require 'octokit'
require 'pp'

exit unless Rails.env.eql?("development")

GITHUB_TOKEN = '19f0011ba073a242cea016a04fb318ab55eddae9'
client = Octokit::Client.new(access_token: GITHUB_TOKEN)


def make_github_string(url) 
  ret = nil
  m = url.match(Resource::GITHUB_PATTERN)
  if m
    ret = m[1..2].join('/')
  end
  return ret
end

def analyze_release(id, rel) 
  # pp rel
  # pp rel.tag_name
  # pp rel.name
  # pp rel.published_at
  puts sprintf("%-30s: %-10s %s\n", id, rel.tag_name, rel.published_at)
end

# Test release date of each program that has a github resource

source_urls = Resource.source_urls.github
puts "#{source_urls.count} source_urls"
source_urls.each do |resource|
  # pp resource
  prog_id = resource.resourceful_id
  github_id = make_github_string(resource.url)
  releases = client.releases(github_id)
  tags = client.tags(github_id)
  puts "%-30s: %3d releases, %3d tags" % [github_id, releases.count, tags.count]
  if releases.count.nonzero?
    latest_release = client.latest_release(github_id)
    analyze_release(github_id, latest_release)
  end
end

# revurl = ResourceType.find_by(name: ResourceType::REV_URL)
# revurl_id = revurl.id

# prog = Program.find_by(name: 'pydicom')
# puts "Prog: #{prog.id}"
# prog_revs = prog.resources
# last_version_rec = prog.versions.order(:date).first
# last_version = last_version_rec.version

# puts "last_version #{last_version}"

# user = Octokit.user 'pydicom'
# puts "user: #{user.first}"
