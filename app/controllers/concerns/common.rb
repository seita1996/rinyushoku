require 'uri'
require 'net/http'

# TODO: Rename
module Common
  extend ActiveSupport::Concern

  def call_api(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    return res.body if res.is_a?(Net::HTTPSuccess)
  end
end
