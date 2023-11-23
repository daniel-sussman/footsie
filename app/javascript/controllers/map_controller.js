import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    pos: Array  }

  connect() {
    console.log(this.posValue);
    mapboxgl.accessToken = this.apiKeyValue
    if (this.posValue) {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v10",
        center: this.posValue,
        zoom: 13
      })
    this.#addMarkersToMap()
    } else {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v10"
      })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    }

  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // const mark = document.createElement('h1')
      // mark.innerText = 'test'
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
