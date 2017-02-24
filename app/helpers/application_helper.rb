module ApplicationHelper
  require 'rss'
  require 'open-uri'
  require 'nokogiri'
  require 'date'

  BLOG_URL = "https://blog.idoimaging.com"
  # BLOG_URL = "http://blog.idoimaging.com.s3-website-us-east-1.amazonaws.com"
  # BLOG_URL = "https://d3h0zniuj3xanb.cloudfront.net"
  XML_URL = "#{BLOG_URL}/feed.xml"

  def url_helper(url)
    url
    # url.match(/^http/) ? url : "http://" + url
  end

  def get_blog_summary
    summaries = []
    begin
      open(XML_URL) do |rss|
        feed = RSS::Parser.parse(rss)
        items = feed.items
        logger.debug("#{items.count} items in blog")
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
      logger.debug("Can not connect to blog url: #{XML_URL}, #{e}")
    end
    summaries
  end

  # https://gist.github.com/suryart/7418454

  def bootstrap_class_for flash_type
    # { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
    error_types = {
      "success" => "alert-success",
      "error" => "alert-danger",
      "alert" => "alert-warning",
      "notice" => "alert-info",
      "recaptcha_error" => "alert-danger",
    }
    result = error_types[flash_type] || flash_type.to_s
    logger.debug("flash_type is #{flash_type} and it is a #{flash_type.class}, returning #{result}")
    return result
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
               concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
               concat message
      end)
    end
    nil
  end


end
