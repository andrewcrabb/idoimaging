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

def find_latest_tag(client, github_id, tags)
  latest_tag = nil
  if tags.count.nonzero?
    # puts "------ tags -------"
    thash = tags.map do |tag|
      commit = client.commit(github_id, tag[:commit][:sha])
      commit_date = commit[:commit][:author][:date]
      [commit_date, tag[:name].strip]
    end.to_h
    latest_tag = thash.sort.last
  end
  return latest_tag
end

# Combine release name with its tag name unless identical

def make_release_name(release)
  [release[:tag_name], release[:name]].uniq.join(' ').strip
end

def find_latest_release(client, github_id, releases)
  latest_release = nil
  if releases.count.nonzero?
    rhash = releases.map { |rel| [rel[:published_at], make_release_name(rel)] }.to_h
    latest_release = rhash.sort.last
  end
  return latest_release
end

def find_latest_release_orig(client, github_id, releases)
  puts "#{github_id}: #{releases.count} releases"
  if releases.count.nonzero?
    begin
      latest = client.latest_release(github_id)
      latest_release = [latest.published_at, latest.tag_name]
    rescue
      puts "Exception: latest_release(#{github_id})"
    end
  end
  return latest_release
end

# latest may be nil

def compare_latest_version(prog_id, latest)
  prog = Program.find(prog_id)
  versions = prog.versions.where.not(date: nil).order(:date)
  latest_version_date = versions.first.date    # Date
  latest_str = ''
  if latest
    latest_date = latest[0].to_date
    is_newer = latest_date <=> latest_version_date
    latest_str = " #{latest_date} '#{latest_date.class}' #{is_newer}"
  end
  puts "#{prog_id} #{latest_version_date} '#{latest_version_date.class}' #{latest_str}"
end

# Test release date of each program that has a github resource

source_urls = Resource.source_urls.github.limit(10)
puts "#{source_urls.count} source_urls"
source_urls.each do |resource|
  prog_id = resource.resourceful_id
  # next unless prog_id.eql? 23
  github_id = make_github_string(resource.url)
  releases = client.releases(github_id)
  tags = client.tags(github_id)
  repo = client.repository(github_id)
  latest_release = find_latest_release(client, github_id, releases)
  latest_tag = find_latest_tag(client, github_id, tags)
  latest = [latest_release, latest_tag].select{ |e| e}.sort{ |a, b| a[0] <=> b[0] }.last
  outstr = "%4d %-30s: %3d releases, %3d tags" % [resource.resourceful_id, github_id, releases.count, tags.count]
  outstr += " latest %-7s %-10s %-6s" % ["release", latest_release[0], latest_release[1]] if latest_release
  outstr += " latest %-7s %-10s %-6s" % ["tag", latest_tag[0], latest_tag[1]] if latest_tag
  outstr += " winner %-10s '%s'" % [latest[0], latest[1]] if latest
  puts outstr
  compare_latest_version(prog_id, latest)
end
