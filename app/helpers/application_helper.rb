module ApplicationHelper
  require 'rss'
  require 'open-uri'
  require 'nokogiri'
  require 'date'

  	BLOG_URL = "http://blog.idoimaging.com"
    XML_URL = "#{BLOG_URL}/feed.xml"

  def url_helper(url)
    url
    # url.match(/^http/) ? url : "http://" + url
  end

  def get_blog_summary
    # url = 'http://localhost:4000/feed.xml'
    summaries = []
    begin
      open(XML_URL) do |rss|
        feed = RSS::Parser.parse(rss)
        items = feed.items
        items [0..2].each do |item|
        	# logger.debug item.inspect
          content = item.content.content
          html_doc = Nokogiri::Slop(content)
          rawdate = item.updated.content
          # logger.debug("rawdate is a #{rawdate.class}")
          datetime = rawdate.strftime("%d %B %Y")
          # logger.debug("datetime is a #{datetime.class}")
          # logger.debug("xxx blog_url #{BLOG_URL}, link #{item.link.href} ")
          summaries << {
            title: item.title.content,
            date: datetime,
            author: item.author,
            link:  "#{BLOG_URL}#{item.link.href}",
            excerpt: html_doc.p.children.first.content
          }
        end
      end
    rescue => e
      # logger.debug("Could not connect to #{url}: #{e}")
      logger.debug("Can not connect to blog url")
    end
    summaries
  end

end
