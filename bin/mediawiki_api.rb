#! /usr/bin/env ruby

require "mediawiki_api"

WIKI_URL = "https://wiki.idoimaging.com/w/api.php"

# client = MediawikiApi::Client.new "http://127.0.0.1:8080/w/api.php"
client = MediawikiApi::Client.new WIKI_URL
text = client.get_wikitext "WebMango"
puts text.inspect

# client.log_in "username", "password" # default Vagrant username and password are "Admin", "vagrant"
# client.create_account "username", "password" # will not work on wikis that require CAPTCHA, like Wikipedia
# client.create_page "title", "content"
# client.get_wikitext "title"
# client.protect_page "title", "reason", "protections" #  protections are optional, default is "edit=sysop|move=sysop"
# client.delete_page "title", "reason"
# client.upload_image "filename", "path", "comment", "ignorewarnings"
# client.watch_page "title"
# client.unwatch_page "title"
# client.meta :siteinfo, siprop: "extensions"
# client.prop :info, titles: "Some page"
# client.query titles: ["Some page", "Some other page"]
