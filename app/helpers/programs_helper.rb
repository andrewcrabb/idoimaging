module ProgramsHelper

  SOCIAL_ICONS = %w(fa-fw social-icon)
  IMAGE_HOST_S3  = 'idoimaging-images.s3.amazonaws.com'
  IMAGE_HOST_CDN = 'images.idoimaging.com'

  def program_version_str(program)
    versions = program.versions.order("date DESC")
    content = latest_version_string(versions).to_s + versions_string(versions).to_s
    render_program_row('Latest version', content) if versions.count > 0
  end

  def render_program_row(title, content)
    params = {title: title, content: content}
    render(partial: 'prog_row', locals: params)
  end

  def platforms_str(program, large = true)
    platform_features = program.features.platforms
    plat_str = platform_features.map { |p| p.value }.join(", ")
    icons = platform_features.map do |platform|
      render(partial: "shared/show_icon", locals: {icon_prefix: platform.icon_prefix, icon: platform.icon, large: large})
    end.join
    title = "#{'Platform'.pluralize(platform_features.count)}: #{plat_str}"
    outstr = content_tag(:span, raw(icons), class: "has-tip", title: title)
    raw(outstr)
  end

  # What's the name of the 'data-tooltip' attribute here and how
  # do I pass it to a content_tag(:span) helper?  Seems to be optional?
  # <span data-tooltip class="has-tip" title="Source code">

  def source_str(program)
    if program.source_urls.count > 0
      languages = program.languages.map { |l| l.value }.join(', ')
      raw(
        content_tag(:span, class: "has-tip", title: "Source code: #{languages}") do
          tag(:i, class: ["fas", "fa-code"])
        end
      )
    end
  end

  def program_link_str(program)
    render_program_row("Get Program", link_to_str(program.home_urls.first))
  end

  def program_authors_str(program)
    content = authors_list_string(program).to_s
    authors = program.authors
    render_program_row(plural_title("Authors", authors), content) if authors.count > 0
  end

  def program_source_str(program)
    source_url = program.source_urls.first
    render_program_row("Get Source", languages_str(source_url.url, program.languages)) if source_url
  end

  def social_handle_str(program, all_resources, network)
    resources = all_resources.select { |k, v| k.eql? network }
    if resources.count > 0
      content = resources[network].map{ |rsrc| make_handle_str(rsrc, network) }.join(',')
      params = {
        title: resources[network].first.resource_type.description,
        content: content,
      }
      render(partial: "prog_row", locals: params)
    end
  end

  def make_handle_str(resource, network)
    content = content_tag(:i, '', class: SOCIAL_ICONS + [resource.icon_prefix, "fa-#{resource.icon}"])
    if resource.description and resource.description.length > 0
      content += "  #{resource.description}"
    else
      content += handle_of_social_url(resource)
    end
    url = (resource.url.match(/^http/)) ? resource.url : "http://#{resource.url}"
    link_to(content, url, {target: 'new', 'data-toggle' => "tooltip", 'data-placement' => "top", 'title' => resource.resource_type.description})
  end

  def handle_of_social_url(resource)
    ret = ''
    if (pattern = ResourceType::SOCIAL_HANDLE_PATTERNS[resource.resource_type.name.to_sym])
      logger.debug("--------- pattern #{pattern.inspect} resource #{resource} ")
      m = resource.url.match(pattern)
      ret = m[:handle]
    end
    return ret
  end

  def program_blog_str(program)
    if blog = program.resources.blogs.first
      content = content_tag(:i, '', class: SOCIAL_ICONS + ["fas", "fa-edit"])
      content += "  #{blog.description}" if blog.description
      render_program_row("Blog", link_to(content, blog.url))
    end
  end

  # Return string for online resources for this program: Demo, video.

  def program_resource_str(program, all_resources)
    content = []
    ResourceType::RESOURCE_TYPES.each do |r_type|
      resources = all_resources.select { |k, v| k.eql? r_type }
      content += resources[r_type].map{ |rsrc| make_handle_str(rsrc, r_type) } if resources[r_type]
    end

    if content.count > 0
      render_program_row("Resources", content.join(' '))
    end
  end

  def user_rating_str(program)
    if user_signed_in?
      prog_rat = raw(content_tag(:div, '', id: 'my-rating'))
    else
      sign_in_path = link_to('Sign in', new_user_session_path)
      prog_rat = "#{sign_in_path} to rate this program"
    end
    render_program_row("Your Rating", prog_rat)
  end

  # Return numerical value of all ratings

  def rating_values(program)
    vals = Rating::RATING_TYPES.keys.map do |rtype|
      prog_rat = program.send("#{rtype}_rating")
      [rtype, prog_rat ? prog_rat.rating : 0]
    end
    Hash[vals]
  end

  # Display stars and half stars for rating 0..5

  def program_rating_str(program)
    half_stars = program.rating ? (program.rating * 2.199).floor : 0
    full_stars = half_stars / 2
    # logger.debug("program #{program.id} rating #{program.rating} full #{full_stars} half #{half_stars}")
    outstr  = raw(content_tag(:i, '', class: ["fas", "fa-star"]) * full_stars)
    outstr += raw(content_tag(:i, '', class: ["fas", "fa-star-half"])) if half_stars.odd?
    return outstr
  end

  def program_rating(program)
    rvals = rating_values(program)
    hasall = rvals.map{ |k, v| v > 0 }.all?
    logger.debug("rvals #{rvals} hasall #{hasall}")
    # hasall currently 0 since scale is not filled in.
    # if hasall
    trating = sprintf("%3.1f", total_rating(rvals))
  end

  # Render rating by IDI

  def idi_rating_str(program)
    render_program_row("IDI Rating", sprintf("%3.1f", program.rating)) if program.rating
    # end
  end

  # @param function HeaderFunction of Platform (call header_functions and platforms)

  def program_features_list(program, feature_type, searchable = false)
    func_str = feature_type.underscore.pluralize
    features = program.features.select { |f| f.category.eql? feature_type }
    if features.count > 0
      feature_str = feature_text(feature_type, features, searchable)
      render_program_row(plural_title(feature_type, features), feature_str)
    end
  end

  def feature_text(feature_type, features, searchable)
    # logger.debug("#{features.count} features")
    ret =  features.map { |feature|
      if searchable
        link_to(feature.value, programs_path(q: {:"#{feature_type.underscore}" => feature.id}))
      else
        feature.value
      end
    }.join(', ')
    return ret
  end

  # Return text for image formats read or written by this program
  #
  # @param program [Program]
  # @param ability [String] 'read' or 'write'

  def program_formats_list(program, ability)
    image_formats = program.send("#{ability}_image_formats").sort_by{ |p| p.name }
    title = ability.titleize + ' ' + plural_title("Format", image_formats)
    render_program_row(title, formats_str(image_formats)) if image_formats.count > 0
  end

  # Programs related to this program
  #
  # @param program [Program]
  # @param relationship [String] Passed to programs_list_str
  # @param title [String]

  def program_related_list(program, relationship, title)
    related = program.send("#{relationship}_programs")
    logger.debug("---------- program #{program.name} relationship #{relationship} related #{related.count} ----------")
    program_list = related.map do |related|
      (related.program_kind.eql? Program::program_kinds[:prerequisite]) ? related.name : link_to(related.name, program_path(related))
    end.join(", ")
    render_program_row(title, program_list) if related.count > 0
  end

  def program_image_slider(program)
    divs = program.images.map do |i|
      content_tag(:div) do
        img = image_tag( image_url(i, true), alt: "Program #{program.id} image")
        link_to(img, image_url(i, false))
      end
    end
    content_tag(:div, raw(divs.join), class: 'slick-slider')
  end

  # Url for this image
  # AWS S3 bucket url (provided by CarrierWave) translated to CloudFront url

  def image_url(i, thumb = false)
    native_url = thumb ? i.image.px350.url : i.image.url
    native_url.gsub(IMAGE_HOST_S3, IMAGE_HOST_CDN)
  end

  # Handle fulltext search for image format

  def fulltext_image_format(search_str)
    image_formats = ImageFormat.where("lower(name) = ?", search_str.downcase)
    ret = nil
    if image_formats.count == 1
      image_format = image_formats.first
      ret = []
      ret[0] = ", which is an image format."
      ret[1] = "You'll get better results by searching by the input file format:<br />"
      ret[1] += raw link_to("Search for #{image_format.name}", programs_path(q: {read_format: image_format.id}))
    end
    return ret
  end

  # Handle fulltext search for feature

  def fulltext_feature(search_str)
    features = Feature.where("lower(value) = ?", search_str.downcase)
    ret = nil
    if features.count == 1
      feature = features.first
      ret = []
      ret[0] = ", which is a feature."
      ret[1] = "You'll get better results by searching by the features:<br />"
      ret[1] += raw link_to("Search for #{feature.value}", programs_path(q: {function: feature.id}))
    end
    return ret
  end

  def external_link_icon(content = '')
    raw(content_tag(:i, content, class: ["fas", "fa-external-link-alt"] ))
  end

  def link_to_str(url)
    raw(link_to(external_link_icon, url, {target: 'new'}))
  end

  def languages_str(source_url, languages)
    str = values_str(languages)
    link_to(external_link_icon, source_url) + "  (#{values_str(languages)})"
  end

  def ratings_table(program)
    # ratings = Hash[program.ratings.map { |p| [p.rating_type, p] }]
    # logger.debug("ratings #{ratings}")
    row_params = program.ratings.map do |r|
      # program_rating = program.send("#{rating_type}_rating")
      logger.debug("rating #{r}")
      {
        title:  r.rating_type.to_s.titleize,
        rating: r.rating
      }
    end
    render partial: 'ratings_table', locals: { row_params: row_params }
  end

  def values_str(features)
    features.map { |feature| feature.value }.join(', ')
  end

  def categories_str(features)
    features.map { |feature| feature.category.gsub(/Function/, '').titleize }.join(', ')
  end

  def plural_title(title, var)
    title.titleize.pluralize(var.count)
  end

  def formats_str(formats)
    raw(
      if formats.count
        formats.map do |format|
          link_to(format.name, image_format_path(format.id))
        end.join(", ")
      else
        "Nil"
      end
    )
  end

  def programs_search_link(platform, format, function)
    ret = 'XXX'
    logger.error("No platform") unless platform
    logger.error("No format") unless format
    logger.error("No function") unless function
    if (platform and format and function)
      query = {platform: platform.id, read_format: format, function: function}
      ret = link_to(platform.value, programs_path({q: query}))
    end
    return ret
  end

  def features_string(program)
    raw (platforms_str(program.platforms, false) + source_str(program))
  end

  # Selectors for Program#index

  def feature_selector(feature, basic = false)
    start = Time.now
    features = basic ? Feature.basic : Feature.all
    selectors = features.selector_values(feature)
    logger.info("feature_selector(#{feature}) Elapsed: #{(Time.now - start) * 1000.0} ms")
    return selectors
  end

  def imageformat_selector(basic = false)
    start = Time.now
    imageformats = basic ? ImageFormat.basic : ImageFormat.all
    selectors = imageformats.selector_values
    logger.info("imageformat_selector Elapsed: #{(Time.now - start) * 1000.0} ms")
    return selectors
  end

    #   @selectors = {
    #   basic_function:    Feature.basic.selector_values(Feature::FUNCTION),
    #   basic_imageformat: ImageFormat.basic.selector_values,
    #   basic_platform:    Feature.basic.selector_values(Feature::PLATFORM)
    # }


end
