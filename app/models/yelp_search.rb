class YelpSearch
  # Constants, do not change these
  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  TOKEN_PATH = "/oauth2/token"
  GRANT_TYPE = "client_credentials"
  SEARCH_LIMIT = 5
  SEARCH_RADIUS = 500

  def initialize client_id, client_secret
    @client_id = client_id
    @client_secret = client_secret
  end

  # Returns your access token
  def bearer_token
    # Put the url together
    url = "#{API_HOST}#{TOKEN_PATH}"

    # Build our params hash
    params = {
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: GRANT_TYPE
    }

    response = HTTP.post(url, params: params)
    parsed = response.parse

    "#{parsed['token_type']} #{parsed['access_token']}"
  end

  # Examples
  #
  #   search("burrito", "san francisco")
  #   # => {
  #          "total": 1000000,
  #          "businesses": [
  #            "name": "El Farolito"
  #            ...
  #          ]
  #        }
  #
  #   search("sea food", "Seattle")
  #   # => {
  #          "total": 1432,
  #          "businesses": [
  #            "name": "Taylor Shellfish Farms"
  #            ...
  #          ]
  #        }
  #
  # Returns a parsed json object of the request
  def search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
      radius: SEARCH_RADIUS,
      limit: SEARCH_LIMIT
    }

    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
  end
end
