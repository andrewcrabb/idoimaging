#! /usr/bin/env ruby

# Useful query: Retrieve all versions that have been tested and either have a nil seen date or a seen date older than tested date
# tested_versions = Version.where.not(last_tested: nil)
# tested_versions.where(last_seen: nil).or(Version.where("last_seen < last_tested"))

require 'httparty'

class CheckWebsite < Thor

  desc 'check_all', 'Check all websites'
  def check_all
    Program.non_githubs.each do |program|
      check_program(program)
    end
  end

  desc 'check NAME', 'Check given program'
  def check(name)
    search_str = "upper(name) like '%#{name.upcase}%'"
    progs = Program.where(search_str)
    if progs.count > 0
      puts "Checking #{progs.count} programs matching '#{name}'"
      progs.each do |prog|
        check_program(prog)
      end
    else
      puts "Program not found: #{name}"
      return
    end
  end

  no_commands do

    def check_program(program)
      rev_urls = program.rev_urls
      unless rev_urls.count.nonzero?
        printf("Program %3d %-40s no rev_url\n", program.id, program.name)
        return
      end

      ver = program.versions.order(:date).last
      unless ver and ver.rev_str
        printf("Program %3d %-40s no rev_str\n", program.id, program.name)
        return
      end

      rev_url = rev_urls.first
      response = HTTParty.get(rev_url.full_url)
      got_response = response.code.eql?(200) && response.body
      foundit = got_response ? response.body.include?(ver.rev_str) : false

      ver.last_tested = Date.today
      ver.last_seen = Date.today if foundit
      ver.save

      # puts "Program #{program.id} #{program.name} rev_url #{rev_url} last version #{ver.version} date #{ver.date} rev_str #{ver.rev_str} "
      printf("Program %3d %-40s last version %15s date %12s rev_str %22s found %s in %6d rev_url %s\n", program.id, program.name, ver.version, ver.date, ver.rev_str, foundit.to_s, response.body.length, rev_url.url)
    end

    def self.setup

    end
  end

end

CheckWebsite.setup
CheckWebsite.start(ARGV)
