# A Google Map Component

We know how to create React components and place them on a page in a Rails application.  Let's take a look at creating a more complex React component that embeds a Google Map in our page.  To accomplish this, we're going to use an NPM module that makes working with Google maps much simpler.

## NPM Modules

NPM is a package manager for Javascript, much like RubyGems are in Ruby.  There is a wide range of funcationality available via NPM that we can use in our web applications.  All of the NPM packages we use in class, and most of the ones you'll come across as you program are open source, meaning the authors have pushlished them and make them avaialbe for you to use free of charge.  Open Source NPM projects, just like the RubyGem counterparts are great places for you to contribute to the community, practice your programming skills, and begin to establish yourself as a programmer.  Listing a few open source projects that you've contributed to is a fantastic way to get your resume to the top of the pile for any job you apply for.

So, how do we use NPM modules inside of our Rails application?  You've actually been doing just that all week.  React itself is an NPM module that gets added to our package.json file.  We're going to add a few more for Google Maps, and let Rail's Asset Pipeline manage them for us and serve them to our webpages.

## Starting a new Rails app.

Its time to start a brand new Rails 5 application that uses React and the google-map-react NPM modules

```
$ rails -v
Rails 5.1.4
$ rails new google-maps-component --webpack=react
$ cd google-maps-component
```

## Finishing the setup of our new Rails application

We're going to be using a view helper to render the React component onto the page, so we add that gem and npm module now.

```
$ echo "gem 'webpacker-react"' >> Gemfile
$ bundle install
$ ./bin/yarn add webpacker-react
```

We need to add a home page, and route to our application.  We'll create a new 'Maps' controller and make its index be the root route of the application

```
$ rails g controller Maps
```

In the routes file, we can set the root routes

#### /config/routes.rb
```ruby
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # add this line
  root to: 'maps#index'
end
```

Finally, we add the view for Maps#index

#### /app/views/maps/index.html.erb
```html
<h1>Map Example</h1>
```

Fire up your Rails app, and you should see a very simple webpage.  No React yet, but hold tight, that's next!


Our sample application is only going to have one Javascript pack, so we'll use the ```application```
 pack that Rails setup for us when we created the application.  Its the file at ```/app/javascripts/packs/application.js``` We can add it to the main layout.

 #### /app/views/layouts/application.html.erb
 ```html
 <!DOCTYPE html>
<html>
  <head>
    <title>GoogleMapsComponent</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

    <!-- Add this line -->
    <%= javascript_pack_tag 'application' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
 ```

## Building a Map Component

Next, we add the google-map-react NPM module to our projects

```
$ ./bin/yarn add google-map-react
```


## Adding a Map component

 We'll start by adding a basic component to make sure that everything is hooked up correctly.  We create a new file to be home to our components

 #### /app/javascripts/components/Map.js
 ```javascript
import React from 'react';

export default class Map extends React.Component {
  render() {
    return (
      <h1>Hello From Map Component</h1>
    )
  }
}
```

Now we can update the ```application.js``` pack to serve the component.  Replace the contents of that file with this:

#### /app/javascript/packs/application.js
```javascript
import Map from 'components/Map'
import WebpackerReact from 'webpacker-react'

WebpackerReact.setup({Map})
```

Then, we add the component to the view:

#### /app/views/maps/index.html.erb

```html
<h1>Map Example</h1>

<!-- add this line -->
<%= react_component("Map") %>
```

## Get a Google Map API key

Google Maps are free to use on your web pages, but you will have to grab an api key from Google to do so.  In a previous tutorial, we showed you how to generate an API key of your own.  Stop and go do that now if you haven't already.

## Add A Gooogle Map

We're ready to add a Google Map to the component.  In this example, we'll add a map centered on LEARN HQ.  At the top of the Map component, we import the module so we can use it.

```javascript
import GoogleMap from 'google-map-react';
```

Then, in the component's render function, we can add a map!

** Note: We're going to add the api key directly to the React Component for this example to keep things as simple as possible.  You wouldn't want to do this generally in your own apps, but rather pass it in on a prop to the component.  We'll show how to do that in a later example.

```javascript
export default class Map extends React.Component {
  render() {
    return (
      <div style={{width: '100%', height: '400px'}}>
        <GoogleMap
          bootstrapURLKeys={{key: this.props.googleApiKey}}
          center={this.props.center}
          zoom={this.props.zoom}
        >
        </GoogleMap>
      </div>
    )
  }
}
```

And there we go.  We now see a map, served up from a React component on our webpage.

![google map](https://s3.amazonaws.com/learn-site/curriculum/google-map/basic-google-map.png)


# Pass Map Settings in from Rails

Your Google Map API key is something that most likely want to manage from the Rails side.  Fortunatly, we can pass the key through to the React component as a prop.  While we're at it, lets also pass the zoom level, and starting center of the map through on props as well.  That way, we have full control of the map on the server side where we can customize it however we like to best suit our user's needs.

## Start in the controller
We're going to store our key and map information in the controller.  You could keep them in your database, or whatever makes sense for your application.

#### /app/controllers/maps_controller.rb
```ruby
class MapsController < ApplicationController
  def index
    @google_api_key = 'AIzaSyD2JVyCN_YW350fIF_631A96zw6_QDmJpM'
    @map_center = [32.7096298,-117.1602029]
    @map_zoom= 18
  end
end
```

In the view, we pass them in as props:

#### /app/views/maps/index.html.erb
```html
<h1>Map Example</h1>

<%= react_component("Map", {
  googleApiKey: @google_api_key,
  center: @map_center,
  zoom: @map_zoom
}) %>
```

Then, in the Map Component, we replace the hard coded values with props:

#### /app/javascript/components/Map.js
```javascript
import React from 'react';
import GoogleMap from 'google-map-react';

export default class Map extends React.Component {
  render() {
    return (
      <div style={{width: '100%', height: '400px'}}>
        <GoogleMap
          bootstrapURLKeys={{key: this.props.googleApiKey}}
          center={this.props.center}
          zoom={this.props.zoom}
        >
        </GoogleMap>
      </div>
    )
  }
}
```

And everything works as expected.  Try changing the values set in the controller to and notice the changes in the way the map renders.

# Add Pins to the map

Google maps have a lot of interactive features that we can make use of in our application.  Perhaps the most common are pins to mark points of interest on the map.  Pins often have interactive features as well.  For example, when the user hovers over a pin, they can be presented with more information about that location.

Pins, when we use React are just regular old components rendered inside of the Map.  Let's look first at our ```<GoogleMap />``` component, and then we'll look at how the ```<Pin />``` component is constructed.

#### /app/javascript/components/Map.js
```javascript
import React from 'react';
import GoogleMap from 'google-map-react';
import Pin from './Pin'

export default class Map extends React.Component {
  render() {
    return (
      <div style={{width: '100%', height: '400px'}}>
        <GoogleMap
          bootstrapURLKeys={{key: this.props.googleApiKey}}
          center={this.props.center}
          zoom={this.props.zoom}
        >
          {/* We can add as many pins as we like to the map.
              Each Pin must have a lat and lng, so Google Maps knows where to place it */}
          <Pin
            title="LEARN"
            lat={32.7096298}
            lng={-117.1602029}
          />
        </GoogleMap>
      </div>
    )
  }
}
```

And here is the Pin component.  Nothing special yet.

#### /apps/javascript/components/Pin.js

```javascript
import React from 'react';

export default class Pin extends React.Component {
  render(){
    return(
      <div>{this.props.title}</div>
    )
  }
}
```

## Pass Pins in from Rails
We want to pass the pins on our map in from Rails, and add the ability to add as many pins as we need.  Let's factor out the hard coded pin values to the Rails view, and pass them in as props.  The View looks like this:

#### /app/views/maps/index.html.haml
```html
<h1>Map Example</h1>

<%# Keep in mind that we are working with a Ruby hash here, which gets translated into a Javascript object as its passed into the component as props. %>
<%= react_component("Map", {
  googleApiKey: @google_api_key,
  center: @map_center,
  zoom: @map_zoom,
  pins: [
  {title: 'LEARN',
   lat: 32.7096298,
   lng: -117.1602029
  }
]

}) %>
```

Then in the Map component, we can iterate over each pin and add it to our map.  One thing to note here about React.  When we display a list of things from an array, each one must have a 'key', so React can keep track of them seperatly.

#### /app/javascript/components/Map.js
```javascript
<GoogleMap
  bootstrapURLKeys={{key: this.props.googleApiKey}}
  center={this.props.center}
  zoom={this.props.zoom}
>
  {/* Loop over all pins from props, and create a Pin  */}
  {this.props.pins.map((pinProps)=>{

    // We pass the props through to the Pin, so it is placed correctly
    return <Pin key={pinProps.title} {...pinProps} />
  })}
</GoogleMap>
```

![Map with Pin](https://s3.amazonaws.com/learn-site/curriculum/google-map/gmap-with-pin.png)


## Challenge
Once you have a pin showing up on your map,  add a Database backed model to store Location data, and pass the locations all the way from your Model to your Google Map.


# Icon

The pin from the last example wasn't very attractive, so lets add an icon to our map, and make a real pin.  We'll also add a tooltip to the pin that shows the name of the location when the user hovers over the pin.  We're going to use another NPM library for our icons called FontAwsome.  There are many, many icon libraries available, each with their own design.  In your own apps, you can use any one that you think looks the best.

The first step is to import react-icons into our project.  From the command line:

```
$ yarn add react-icons
```

Then in our Pin component, we can import the 'map-pin' and use it:

#### /app/javascript/components/Pin.js

```javascript
import React from 'react';
import MapPin from 'react-icons/lib/fa/map-pin';

export default class Pin extends React.Component {
  render(){
    return(
      <div><MapPin /></div>
    )
  }
}
```

That works, but the pin is kind of small and hard to see.  Let's add some style to the Pin component and spruce things up a bit.  We're going to use the style prop that is available on all React components.  Passing in styles in React works just like normal css, with one big exception.  Any CSS attribute that has a dash '-' in its name, is replaced with its camel case syntax instead.  For example, this CSS rule: ```background-color: blue;```  would be ```backgroundColor: 'blue'``` in a React component.

Here's some basic style for our map pin to give you a better idea of how this works:


#### /app/javascript/components/Pin.js

```javascript
import React from 'react';
import MapPin from 'react-icons/lib/fa/map-pin';

const PinStyles = {
  fontSize: '24px',
  color: 'red'
}
export default class Pin extends React.Component {
  render(){
    return(
      <div style={PinStyles}><MapPin /></div>
    )
  }
}
```

And that renders a pin that looks much nicer:

![styled map pin](https://s3.amazonaws.com/learn-site/curriculum/google-map/styled-map-pin.png)


# Pin interaction
Now we have a Pin on our map that looks nice, but we also want to show the user the name of the location when they hover over it.  We can use React to add this interactivity, with a little help from Google Maps.  Google Maps passes in a prop to our compoment called ```$hover```, that is true when the user is hovering over the pin, and false otherwise.  Its exactly what we need to show or hide our tooltip. We'll also add in some style for the tooltip so it looks nice.


#### /app/javascript/components/Pin.js

```javascript
import React from 'react';
import MapPin from 'react-icons/lib/fa/map-pin';

const PinStyles = {
  fontSize: '24px',
  color: 'red'
}

// Some styles to make the tooltip look nice, and render in the correct spot
const TooltipStyles = {
  border: '1px solid red',
  backgroundColor: 'white',
  padding: '6px',
  position: 'absolute',
  bottom: '0px',
  width: '30px'
}

export default class Pin extends React.Component {
  render(){
    return(
      <div>

        // Google Maps passes in $hover and manages it for us
        {this.props.$hover &&
          <div style={TooltipStyles}>{this.props.title}</div>
        }
        <div style={PinStyles}><MapPin /></div>
      </div>
    )
  }
}

```

![tooltip](https://s3.amazonaws.com/learn-site/curriculum/google-map/tooltip.png)

# Get a Yelp API key

For our final example using Google Maps, we're going to integrate a search of the Yelp database, and show locations on our map.  To do this, we'll need an API key from Yelp.  The process is much the same as Google's API key.  You'll want to make sure you're logged into Yelp, and then navigate to this page to get started:

[Yelp API Authentication](https://www.yelp.com/developers/documentation/v3/authentication)

Follow the example in the video above to create your own Yelp App, and generate a key.



# Yelp

In this example, we're going to accept input from the user to perform a search against the Yelp API, and display the results to the user on our Google Map.  This will be a great chance for us to use two different APIs together to make a great experience for our users.

## Install the HTTP Gem

The first thing we need to do is install the HTTP gem to allow us to make requests to Yelp for business information.  Its interesting to note here that the Yelp API is on V3, and there currently isn't a complete gem for Ruby developers to use like there is for V2.  If you are looking for a great open source project to lead, creating a gem that packages the Yelp Fusion API is an opportunity to jump in.

In the Rails project from our previous Google Map examples, lets make a new branch using Git, and add the HTTP gem.

```
$ git commit -am "showing a google map, and pins"
$ git checkout -b yelp-integration
$ echo "gem 'http'" >> Gemfile
$ bundle install
```

## Search Yelp
Now that our dependencies are in place, we can make a call out to the Yelp API.  There are two components of a search call.  First we need to get a token using the client id and secret that we obtained from the Yelp website.  Once we have a token, we can use it to do the actual search for businesses.

We'll put the file with our Yelp API code in our /app/models directory, and call it 'YelpSearch.rb':

#### /app/models/yelp_search.rb

```ruby
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
      radius: SEARCH_RADIUS,  # Distance in meters from location for search
      limit: SEARCH_LIMIT # Number of results to return
    }

    # calling search first fetches a bearer_token, then makes the search request
    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
  end
end
```
With the code above, we can perform search requests against the Yelp API like so:

```ruby
yelp_search = YelpSearch.new(client_id, client_secret)
result = yelp_search.search("tacos", "San Diego")
```

This is exactly what we'll need in the controller when it comes time to work with user submitted searches.

## Adding a Search Form

Next, we turn our attention to the Search form on the page.  Our form will work like the other Rails forms that we are already familiar with.  We add this markup to the top of our page:

#### /app/views/maps/index.html.erb
```html
<%= form_tag root_path, method: :get do %>
  <%= text_field_tag :search, params[:search] %><%= submit_tag "Search San Diego" %>
<% end %>
```

In the controller, we pass along the user input to Yelp, and handle the response:

#### /app/controllers/maps_controller.rb
```ruby
class MapsController < ApplicationController
  def index

    @google_api_key='< Your Google Map API Key >'
    @map_center = [32.7096298,-117.1602029]
    @map_zoom= 18

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
```

## Pass pins along to React Component

Finally, we just need to pass the pins from Yelp along to the React component.  Here is the complete index.html.erb file:

#### /app/views/maps/index.html.erb
```html
<h1>Map Example</h1>

<%= form_tag root_path, method: :get do %>
  <%= text_field_tag :search, params[:search] %><%= submit_tag "Search San Diego" %>
<% end %>

<!-- We add @pins in the props passed to the Map component -->
<%= react_component("Map", {
  googleApiKey: @google_api_key,
  center: @map_center,
  zoom: @map_zoom,
  pins: @pins
}) %>
```

## Finishing Up

You'll notice that our map is now zoomed in too far when the page loads, and you need to zoom out to see the pins.  Let's start with a zoom of 13 for a better chance that the pins will show immediatly on the map.

Change the @map_zoom in the controller to be 11:

#### /app/controllers/map_controller.rb
```ruby
@map_zoom= 11
```

Also, our tooltip style needs a little adjustment so it looks nice with longer text.  We update the Pin component like so:

#### /app/javascript/components/Pin.js

```javascript
import React from 'react';
import MapPin from 'react-icons/lib/fa/map-pin';

const PinStyles = {
  fontSize: '24px',
  color: 'red'
}

const TooltipStyles = {
  border: '1px solid red',
  backgroundColor: 'white',
  padding: '6px',
  position: 'absolute',
  bottom: '0px',
  width: '60px'  // <--- Change this to be 60 px wide
}

export default class Pin extends React.Component {
  render(){
    return(
      <div>
        {this.props.$hover &&
          <div style={TooltipStyles}>{this.props.title}</div>
        }
        <div style={PinStyles}><MapPin /></div>
      </div>
    )
  }
}
```
## Challenges

1) Add additional information from the Yelp API to the tooltip for returned locations.  Some suggestions of things you can add:
  - hours of opperation
  - price range
  - open or closed
  - category

2) Allow user to search different cities
3) Allow users to specify a category of businesses to search
4) Allow users to "like" locations, and persist those locations in a Database
