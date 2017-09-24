class Ncaa
  attr_accessor :response

  BASE_URL = 'http://data.ncaa.com'

  def initialize(endpoint)
    resp = RestClient.get(BASE_URL + endpoint)
    @response = JSON.parse(resp)
  rescue RestClient::NotFound
    puts 'Endpoint not found'+ endpoint
    @response = nil
  end
end
