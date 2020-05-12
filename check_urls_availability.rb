require_relative 'url_checker'
require_relative 'url_extractor'

file = 'websites_to_check.csv'
threads = 2

all_urls = UrlExtractor.new(file: file).result_urls
group_size = (all_urls.count / threads.to_f).ceil

all_urls.each_slice(group_size) do |urls_group|
  Thread.new do
    urls_group.each do |url|
      result = UrlChecker.check(url: url)
      p "#{url} status: #{result[:status]}, accessible: #{result[:accessible]}"
    end
  end.join
end
