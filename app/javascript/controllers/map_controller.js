import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number,
    shops: Array
  }

  connect() {
    this.loadMap()
  }

  async loadMap() {
    // Check if Leaflet is available
    if (typeof L === 'undefined') {
      // Load Leaflet dynamically
      const script = document.createElement('script')
      script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js'
      script.onload = () => this.initMap()
      document.head.appendChild(script)
    } else {
      this.initMap()
    }
  }

  initMap() {
    const map = L.map(this.element).setView(
      [this.latitudeValue || 39.7392, this.longitudeValue || -104.9903], 
      12
    )

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map)

    // Add markers for each shop
    const shops = this.shopsValue || []
    shops.forEach(shop => {
      if (shop.latitude && shop.longitude) {
        const marker = L.marker([shop.latitude, shop.longitude])
          .addTo(map)
          .bindPopup(`<strong>${shop.name}</strong>`)
        
        marker.on('click', () => {
          this.highlightShop(shop.id)
        })
      }
    })
  }

  highlightShop(shopId) {
    const shopCard = document.querySelector(`[data-shop-id="${shopId}"]`)
    if (shopCard) {
      shopCard.scrollIntoView({ behavior: 'smooth', block: 'center' })
      shopCard.classList.add('ring-2', 'ring-sky-500')
      setTimeout(() => {
        shopCard.classList.remove('ring-2', 'ring-sky-500')
      }, 2000)
    }
  }
}
