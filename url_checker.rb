require 'net/http'

class UrlChecker
  def self.check(url:)
    result = { accessible: true, status: 200 }

    url = URI.parse(url)
    request = Net::HTTP.new(url.host, url.port)
    request.use_ssl = (url.scheme == 'https')
    path = url.path.empty? ? '/' : url.path
    head = request.request_head(path)

    # Consider redirects
    if head.code[0] == '3' && head['location']
      return UrlChecker.check(url: head['location'])
    end

    result[:status] = head.code
    result[:accessible] = head.code[0].to_i < 3
    
    result
  rescue Errno::ENOENT, SocketError
    { accessible: false, status: 0 }
  end
end
