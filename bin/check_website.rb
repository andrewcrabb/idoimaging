#! /usr/bin/env ruby

# Useful query: Retrieve all versions that have been tested and either have a nil seen date or a seen date older than tested date
# tested_versions = Version.where.not(last_tested: nil)
# tested_versions.where(last_seen: nil).or(Version.where("last_seen < last_tested"))

require 'httparty'

# My libraries
require_relative '../lib/checkable.rb'

include Checkable

class CheckWebsite < Thor

  desc 'check_all', 'Check all websites'
  def check_all
    check_programs(Program.non_githubs)
  end

  desc 'check_github', 'Check all GitHub sites'
  def check_github
    check_programs(Program.githubs)
  end

  desc 'check_bitbucket', 'Check all BitBucket sites'
  def check_bitbucket
    check_programs(Program.bitbuckets)
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

    def check_programs(programs)
      programs.each do |program|
        program.check_for_update
      end
    end

    def self.setup

    end
  end

end

CheckWebsite.setup
CheckWebsite.start(ARGV)
