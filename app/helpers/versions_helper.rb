module VersionsHelper

  # Return string of latest version, with additional versions if they exist
  # 
  # @param versions [Collection<Version>]
  # @return [String]

  def latest_version_string(versions)
    versions = versions.select { |v| v && (v.date || v.version) }
    str = version_string(versions.first)
    icon = content_tag(:i, '', class: ["fa", "fa-angle-double-down", "fa-lg"])
    str += content_tag(:span, icon, {id: "show_history"}) if versions.count > 1
    return str
  end

  # Return string summarizing this version
  # Format: "1.1 (June 2016)" or "1.1" or "June 2016" depending on info avialable
  # 
  # @param ver [Version]
  # @return [String]

  def version_string(ver)
    if ver && (ver.date || ver.version)
      date_str = ver.date ? ver.date.strftime("%B %Y") : nil
      ver_str = ver.version ? ver.version : nil
      outstr = (date_str && ver_str) ? "#{ver_str} (#{date_str})" : (date_str || ver_str)
    else
      ver = ''
    end
    return outstr
  end

  # Call version_string for each version
  # 
  # @param versions [Collection<Version>]
  # @return [String]

  def versions_string(versions)
    if versions.count > 0
      versions_str = raw(versions[1..4].map{ |v| version_string(v) + "<br>" }.join)
      content_tag(:div, versions_str, {id: 'versions_div'})
    end
  end

  def recent_versions(n = 30)
    Version.where("date > ?", Date.today - n.days)
  end

end
