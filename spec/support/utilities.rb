include ApplicationHelper

def full_title(page_title)
  base_title = "Aplicacion muestra del tutorial de Ruby on Rails"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end