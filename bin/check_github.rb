#! /usr/bin/env ruby

require 'octokit'
require 'pp'

exit unless Rails.env.eql?("development")

GITHUB_TOKEN = '19f0011ba073a242cea016a04fb318ab55eddae9'
client = Octokit::Client.new(access_token: GITHUB_TOKEN)

def github_repo(url)
  ret = nil
  m = url.match(Resource::GITHUB_PATTERN)
  if m
    ret = m[1]
  end
  return ret
end

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

def find_latest_tag(client, github_id, tags)
  latest_tag = nil
  if tags.count.nonzero?
    thash = {}
    # puts "------ tags -------"
    tags.each do |tag|
      # pp tag
      # commit = tag[:commit]
      commit_sha = tag[:commit][:sha]
      commit = client.commit(github_id, commit_sha)
      commit_date = commit[:commit][:author][:date]
      # puts "%-10s %s" % [tag[:name], commit_date]
      thash[commit_date] = tag[:name]
    end
    latest_tag = thash.sort.last
  end
  return latest_tag
end

def find_latest_release(client, github_id, releases)
  if releases.count.nonzero?
    latest = client.latest_release(github_id)
    latest_release = [latest.published_at, latest.tag_name]
    # analyze_release(github_id, latest_release)
  end
  return latest_release
end

# Test release date of each program that has a github resource

source_urls = Resource.source_urls.github.limit(30)
puts "#{source_urls.count} source_urls"
source_urls.each do |resource|
  # pp resource
  prog_id = resource.resourceful_id
  github_id = make_github_string(resource.url)
  releases = client.releases(github_id)
  tags = client.tags(github_id)
  repo = client.repository(github_id)
  latest_release = find_latest_release(client, github_id, releases)
  latest_tag = find_latest_tag(client, github_id, tags)
  outstr = "%4d %-30s: %3d releases, %3d tags" % [resource.resourceful_id, github_id, releases.count, tags.count]
  outstr += " latest %-7s %-10s %-6s" % ["release", latest_release[0], latest_release[1]] if latest_release
  outstr += " latest %-7s %-10s %-6s" % ["tag", latest_tag[0], latest_tag[1]] if latest_tag
  puts outstr

  # tags.each do |tag|
  #   pp tag
  # end
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
