#! /usr/bin/env ruby

module Checkable
	def check_for_update
		puts "check_for_update: name #{name}"
		if github?
			check_github
		elsif bitbucket?
			check_bitbucket
		else
			check_rev_url
   end

   def github?
    puts "I am github?"
    resources.map{ |r| r.github? }.any?
  end

  def bitbucket?
    resources.map{ |r| r.bitbucket? }.any?
  end

  def check_rev_url
    unless rev_urls.count.nonzero?
      printf("Program %3d %-40s no rev_url\n", id, name)
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

  end
end