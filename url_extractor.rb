require 'csv'

class UrlExtractor
  attr_reader :file
  attr_reader :result_urls

  def initialize(file:)
    @file = file
    @result_urls = transform_url_list
  end

  private

  def transform_url_list
    CSV.read(file, headers: true).map do |row|
      url = row['URL']

      url.start_with?('http') ? url : 'http://' + url
    end
  end
end
