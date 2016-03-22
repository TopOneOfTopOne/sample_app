module ApplicationHelper
  def add_title_text(title)
    base_title_text = 'My first app'
    return "#{title} | #{base_title_text}" unless title.blank? || title.nil?
    base_title_text
  end

  def add_header_text(title)
    title
  end
end