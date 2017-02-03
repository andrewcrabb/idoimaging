module AuthorsHelper

  def authors_list_string(program)
    # Come back to this
    # authors.map do |author|
    return '' unless program.authors.count > 0
    author = program.authors.first
    content = link_to(author.common_name, programs_path(q: {author: author.id}))
    programs = author.programs.where.not(id: program.id).order(:name)
    if programs.count > 1
      content += author_show_dropdown(programs)
      content += author_programs_string(programs)
    end
    # end.join(', ')
    return content
  end

  def author_show_dropdown(programs)
    double_down = content_tag(:i, "", class: ["fa", "fa-angle-double-down", "fa-lg"])
    content = raw(content_tag(:span, double_down, {id: "show_programs"}))
    content += content_tag(:span, "(#{programs.count} other #{'program'.pluralize(programs)})", {id: "show_programs_text"})
    return content
  end

  def author_programs_string(programs)
    content = raw programs.map{ |p| link_to(p.name, program_path(p)) }.join(tag(:br))
    content_tag(:div, content, {id: 'programs_div'})
  end

end
