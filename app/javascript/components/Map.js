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
          {/* Loop over all pins from props, and create a Pin  */}
          {this.props.pins.map((pinProps)=>{

            // We pass the props through to the Pin, so it is placed correctly
            return <Pin key={pinProps.title} {...pinProps} />
          })}
        </GoogleMap>
      </div>
    )
  }
}
