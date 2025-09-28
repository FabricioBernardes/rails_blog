module PostsHelper
  def format_post_date(date)
    return "Not published" if date.nil?
    date.strftime("%B %d, %Y")
  end

  def author_display_name(user)
    return "Unknown Author" if user.nil?
    user.email.split("@").first.titleize
  end

  def post_excerpt(body, length = 150)
    return "" if body.blank?
    truncate(body.to_s.strip, length: length)
  end
end
