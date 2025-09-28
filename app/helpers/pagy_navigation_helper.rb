module PagyNavigationHelper
  def pagy_simple_nav(pagy)
    html = +%(<nav class="flex gap-1 mt-4 mb-24">)

    if pagy.prev
      html << %(<a href="#{pagy_url_for(pagy, pagy.prev)}" class="px-3 py-2 border border-gray-200 rounded-md text-gray-700 bg-white hover:bg-gray-100 text-sm transition-all">Previous</a>)
    else
      html << %(<span class="px-3 py-2 border border-gray-200 rounded-md text-gray-400 bg-gray-100 text-sm cursor-not-allowed">Previous</span>)
    end

    pagy.series.each do |item|
      if item.is_a?(Integer)
        html << %(<a href="#{pagy_url_for(pagy, item)}" class="px-3 py-2 border border-gray-200 rounded-md text-gray-700 bg-white hover:bg-gray-100 text-sm transition-all">#{item}</a>)
      elsif item.is_a?(String)
        html << %(<span class="px-3 py-2 border border-blue-600 rounded-md bg-blue-500 text-white text-sm">#{item}</span>)
      elsif item == :gap
        html << %(<span class="px-3 py-2 text-gray-700 text-sm">...</span>)
      end
    end

    if pagy.next
      html << %(<a href="#{pagy_url_for(pagy, pagy.next)}" class="px-3 py-2 border border-gray-200 rounded-md text-gray-700 bg-white hover:bg-gray-100 text-sm transition-all">Next</a>)
    else
      html << %(<span class="px-3 py-2 border border-gray-200 rounded-md text-gray-400 bg-gray-100 text-sm cursor-not-allowed">Next</span>)
    end

    html << %(</nav>)
    html.html_safe
  end

  def pagy_url_for(pagy, page)
    params = request.query_parameters.merge(pagy.vars[:page_param] => page)
    url_for(params)
  end
end
