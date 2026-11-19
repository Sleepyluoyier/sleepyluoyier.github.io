# Give local assets a new URL on each successful site build.
# This covers theme CSS, JavaScript, the avatar and post images without
# overriding Chirpy's head/sidebar templates.
Jekyll::Hooks.register :site, :post_render do |site|
  version = site.time.to_i.to_s
  prefix = Regexp.escape("#{site.config.fetch('baseurl', '')}/assets/")
  asset_attribute = /(<(?:link|script|img|source|video|audio)\b[^>]*?\b(?:src|href|poster)=)(["'])(#{prefix}[^"']+)\2/i

  (site.pages + site.documents).each do |page|
    next unless page.output_ext == '.html' && page.output

    page.output = page.output.gsub(asset_attribute) do
      opening, quote, url = Regexp.last_match.captures
      path, fragment = url.split('#', 2)
      separator = path.include?('?') ? '&amp;' : '?'
      updated = "#{path}#{separator}v=#{version}"
      updated += "##{fragment}" if fragment
      "#{opening}#{quote}#{updated}#{quote}"
    end
  end
end
