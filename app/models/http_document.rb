class HTTPDocument < Document

  def eligible_for_cache?
    if has_attribute? :cached_at
      return cached_at < 3.days.ago
    else
      return true
    end
  end

end