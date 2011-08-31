module ApplicationHelper

  # Return a web site logo here
  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end


  # Return a title per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      # "#{base_title} | @title"    --- Fail
      # "#{base_title} | #{title}"  --- Fail
      # #{base_title} | #{@title} ----- Fail
      # base_title + " | " + @title --- OK
      # "#{base_title} | #{@title}" --- OK
      "#{base_title} | #{@title}"
    end
  end

end
