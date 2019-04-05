#! /usr/bin/env ruby

require 'octokit'
require 'pp'

module Github

# exit unless Rails.env.eql?("development")

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

# Combine release name with its tag name unless identical

def make_release_name(release)
  [release[:tag_name], release[:name]].uniq.join(' ').strip
end

def find_latest_release(client, github_id)
  releases = client.releases(github_id)
  latest_release = nil
  if releases.count.nonzero?
    rhash = releases.map { |rel| [rel[:published_at], make_release_name(rel)] }.to_h
    latest_release = rhash.sort.last
  end
  return latest_release
end

def find_latest_tag(client, github_id, tags)
  latest_tag = nil
  tags = client.tags(github_id)
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

# Create a new Version record for the given program.

def create_new_version(prog, latest)
  puts "create_new_version(#{prog.id}, #{latest})"
  ver = prog.versions.create(
    version: latest[1],
    date: latest[0],
    )
end


# latest may be nil.  Checks all versions (including unpublished) and creates a 
# new Version record if latest is newer than latest version.

def compare_latest_version(prog_id, latest)
  prog = Program.find(prog_id)
  versions = prog.versions.where.not(date: nil).order(:date)
  latest_version = versions.first
  if latest_version.nil?
    puts "ERROR: Nil version in prog #{prog.id} #{prog.name}"
    return
  end
  if latest
    latest_date = latest[0].to_date
    is_newer = latest_date <=> latest_version.date
    create_new_version(prog, latest) if (is_newer > 0)
    # latest_str = " #{latest_date} '#{latest_date.class}' #{is_newer}"
  end
  # puts "#{prog_id} #{latest_version_date} '#{latest_version_date.class}'"
end

def check_github
  check_url = source_url or rev_url
  github_id = make_github_string(check_url.url)

end

end

# Test release date of each program that has a github resource.
# Note that rev_url can also be github, but currently all programs with github rev_url also have github source_url

source_urls = Resource.source_urls.githubs
puts "#{source_urls.count} source_urls"
source_urls.each do |resource|
  prog_id = resource.resourceful_id
  # next unless prog_id.eql? 93
  github_id = make_github_string(resource.url)
  next unless github_id
  # repo = client.repository(github_id)
  latest_release = find_latest_release(client, github_id)
  latest_tag = find_latest_tag(client, github_id, tags)
  latest = [latest_release, latest_tag].select{ |e| e}.sort{ |a, b| a[0] <=> b[0] }.last
  # outstr = "%4d %-30s: %3d releases, %3d tags" % [resource.resourceful_id, github_id, releases.count, tags.count]
  outstr = " %s %s '%s'" % ["release", latest_release[0], latest_release[1]] if latest_release
  outstr += " %s %s '%s'" % ["tag", latest_tag[0], latest_tag[1]] if latest_tag
  outstr += " winner %s '%s'" % [latest[0], latest[1]] if latest
  puts outstr
  compare_latest_version(prog_id, latest)
end
