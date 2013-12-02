module ApplicationHelper
  def link(rel, method, url)
    {
        :rel => rel,
        :method => method,
        :url => url
    }
  end
end
