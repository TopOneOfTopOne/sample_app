module ApplicationHelper
  def add_title_text(title)
    base_title_text = 'Generic title here :)'
    return "#{title} | #{base_title_text}" unless title.blank? || title.nil?
    base_title_text
  end

  def add_header_text(title)
    base_header_text = 'Header right here'
    return "#{title} | Generic header here :)" unless title.blank? || title.nil?
    base_header_text
  end
end