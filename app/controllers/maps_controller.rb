class MapsController < ApplicationController
  def index
    @google_api_key = '< Your Google Maps API KEy >'
    @map_center = [32.7096298,-117.1602029]
    @map_zoom= 11

    @yelp_client_id='< Your Yelp Client ID >'
    @yelp_client_secret='< Your Yelp Client Secret >'

    # If user has submitted search
    if(params["search"])
      yelp_search = YelpSearch.new(@yelp_client_id, @yelp_client_secret)
      results = yelp_search.search(params["search"], "San Diego")

      # Parse the result returned from Yelp, and create our pins
      @pins = results["businesses"].map do |business|
        {
          title: business["name"],
          lat: business["coordinates"]["latitude"],
          lng: business["coordinates"]["longitude"],
        }
      end
    else # Otherwise, just return empty set of pins
      @pins = []
    end
  end
end
