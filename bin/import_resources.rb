#! /usr/bin/env ruby

require 'Mysql2'
require_relative '../app/models/resource'
require_relative '../app/models/resource_type'

Resource.delete_all

# Hack to avoid id = 1 which Ransack cannot handle (see my wiki).
# This only needs to be done on searchable fields (ie not Program).
Resource.create!(url: 'FALSE')
Resource.last.delete

def make_resource(resource_type_name, url)
  if (url and url.length > 0)
    puts "Creating resource: #{resource_type_name}, #{url}"
    resource_type = ResourceType.find_by(name: resource_type_name)
    r = Resource.find_or_create_by(
      resource_type: resource_type,
      url:           url
    )
  end
end

Rails.logger.level = :debug
$c = Mysql2::Client.new(default_file: '~/.my.cnf', default_group: 'idoimaging', database: 'imaging')

sql  = "select *"
sql += " from author"
rslt = $c.query(sql, :symbolize_keys => true)
a = nil
rslt.each do |r|
  # puts "Creating author: #{r[:name_last]} (#{r[:home]}) (initially #{Author.all.count}) "
  a = Author.find_by(
    name_last:   r[:name_last],
    # name_first:  r[:name_first],
    # institution: r[:institution],
    # country:     r[:country],
  )
  unless a
    puts "No author found: #{r[:name_last]}"
    # exit
    next
  end
  if r[:home] and r[:home].length > 0
    homeurl = make_resource('home_url', r[:home])
    a.resources << homeurl
  end
end
# exit

sql = "select *"
sql += " from program"
sql += " where remdate like '0000-00-00'"
# sql += " and name like 'DCM4CHEE%'"
sql += " and ident >= 100"
sql += " order by name"
# sql += " limit 10"
rslt = $c.query(sql, :symbolize_keys => true)
puts "#{rslt.count} results returned"
rslt.each do |r|
  p = Program.find_by_name(r[:name])
  unless p
    puts "No program found: #{r[:name]}"
    next
  end
  puts "----- #{p.name} -----"
  (rsrc = make_resource(ResourceType::SOURCE_URL, r[:srcurl]))   && p.resources << rsrc
  (rsrc = make_resource(ResourceType::HOME_URL  , r[:homeurl]))  && p.resources << rsrc
  (rsrc = make_resource(ResourceType::REV_URL   , r[:revurl]))   && p.resources << rsrc
  # (rsrc = make_resource(ResourceType::COUNT_URL , r[:counturl])) && p.resources << rsrc
  # p.save!
end
