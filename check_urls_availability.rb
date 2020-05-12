require 'getoptlong'
require_relative 'url_checker'
require_relative 'url_extractor'

file = 'websites_to_check.csv'
threads = 2

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--file', '-f', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--threads', '-t', GetoptLong::OPTIONAL_ARGUMENT]
)

opts.each do |opt, arg|
  case opt
    when '--help'
      puts <<-EOF
        hello [OPTION] ... DIR

        --help, -h:
        Shows help. Oh, you already know it:-)

        --file [path], -f [path]:
        Path to csv file with urls. Default value is 'websites_to_check.csv'.

        --threads x:
        Number of threads to run the checks simultaneously. Default value is 2.
      EOF
    when '--file'
      file = arg
    when '--threads'
      threads = arg.to_i
  end
end

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
