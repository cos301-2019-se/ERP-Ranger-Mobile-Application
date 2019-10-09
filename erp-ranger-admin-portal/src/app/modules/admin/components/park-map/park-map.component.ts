import { Component, OnInit, Input, AfterViewInit, OnChanges, SimpleChange } from '@angular/core';
import * as mapboxgl from 'mapbox-gl';
import { Park } from 'src/app/models/Park.model';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-park-map',
  templateUrl: './park-map.component.html',
  styleUrls: ['./park-map.component.scss']
})
export class ParkMapComponent implements OnInit, AfterViewInit, OnChanges {
  @Input() park: Park;
  @Input() parks: Park[];
  @Input() markers;
  @Input() rangers;
  @Input() reports;
  @Input() fixed: boolean;

  storedChanges: SimpleChange;

  size = 200;
  map: mapboxgl.Map;

  pulsingDotReport;
  pulsingDotRanger;
  pulsingDotMarker;

  constructor() { }

  ngOnInit() { }

  ngAfterViewInit() {
    this.fixParkData();
    this.setupMap();
    this.buildMapBase();
  }

  ngOnChanges(changes: any) {
    if (this.map) {
      if (changes['reports'] && (changes['reports'].currentValue !== changes['reports'].previousValue)) {
        this.setupReports(changes['reports'].currentValue);
      }
      if (changes['rangers'] && (changes['rangers'].currentValue !== changes['rangers'].previousValue)) {
        this.setupRangers(changes['rangers'].currentValue);
      }
      if (changes['markers'] && (changes['markers'].currentValue !== changes['markers'].previousValue)) {
        this.setupMarkers(changes['markers'].currentValue);
      }
      if (changes['fixed'] && (changes['fixed'].currentValue !== changes['fixed'].previousValue)) {
        this.fixed = changes['fixed'].currentValue;
        this.mapRefresh();
      }
    } else {
      this.storedChanges = changes;
    }
  }

  fixParkData() {
    // Swapping lat and lng for coordinates to ensure correct output
    if (this.park) {
      for (let i = 0; i < this.park.fence.geoJson.coordinates[0].length; i++) {
        this.park.fence.geoJson.coordinates[0][i].reverse();
      }
    } else if (this.parks) {
      for (let i = 0; i < this.parks.length; i++) {
        for (let j = 0; j < this.parks[i].fence.geoJson.coordinates[0].length; j++) {
          this.parks[i].fence.geoJson.coordinates[0][j].reverse();
        }
      }
    }
  }

  setupMap() {
    mapboxgl.accessToken = environment.mapbox.accessToken;
    let center = null;
    if (this.park) {
      center = [
        this.park.fence.geoJson.coordinates[0][0][0],
        this.park.fence.geoJson.coordinates[0][0][1]
      ];
    } else {
      center = [
        28.278051304132134,
        -25.77998666415725
      ]
    }
    this.map = new mapboxgl.Map({
      container: 'map',
      // style: 'mapbox://styles/mapbox/streets-v11',
      style: 'mapbox://styles/erp-rangers/ck11chqnc0eds1cugiybx7eyl',
      // style: 'mapbox://styles/erpngo/cjwrwfig29f9z1cqtsqmsnegp',
      center: center,
      zoom: 10
    });
    this.setupDots();
    if (this.storedChanges) {
      //this.ngOnChanges(this.storedChanges);
      this.storedChanges = null;
    }
  }

  buildMapBase() {
    this.map.on('load', () => {
      // Setup Custom Images
      this.map.addImage('pulsing-dot-report', this.pulsingDotReport, { pixelRatio: 2 });
      this.map.addImage('pulsing-dot-ranger', this.pulsingDotRanger, { pixelRatio: 2 });
      this.map.addImage('pulsing-dot-marker', this.pulsingDotMarker, { pixelRatio: 2 });

      this.map.resize();

      // Display fence for a park or for multiple parks
      if (this.park && !this.parks) {
        this.map.addLayer({
          'id': this.park.id,
          'type': 'fill',
          'source': {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'geometry': {
                'type': this.park.fence.geoJson.type,
                'coordinates': this.park.fence.geoJson.coordinates
              }
            }
          },
          'layout': {},
          'paint': {
            'fill-color': '#fc4e03',
            'fill-opacity': 0.15
          }
        });
        this.zoomToPark();
        this.mapRefresh();
      } else if (this.parks) {

      }

      // Display markers in a park
      this.setupReports(this.reports);

      // Display rangers in a park
      this.setupRangers(this.rangers);

      // Display reports in a park
      this.setupMarkers(this.markers);

    });
  }

  mapRefresh() {
    if (this.fixed) {
      this.map['dragPan'].disable();
      this.map['scrollZoom'].disable();
    }
  }

  getParkBounds(park) {
    let n = null;
    let e = null;
    let s = null;
    let w = null;
    // Get extremes for the park edges
    for (let i = 0; i < park.fence.geoJson.coordinates[0].length; i++) {
      const coordinates = park.fence.geoJson.coordinates[0][i];
      if ((n == null) || (n > coordinates[1])) {
        n = coordinates[1];
      }
      if ((s == null) || (s < coordinates[1])) {
        s = coordinates[1];
      }
      if ((e == null) || (e > coordinates[0])) {
        e = coordinates[0];
      }
      if ((w == null) || (w < coordinates[0])) {
        w = coordinates[0];
      }
    }
    return [
      [w, s],
      [e, n]
    ].reverse();
  }

  zoomToPark() {
    if (this.park && !this.parks) {
      const bounds = this.getParkBounds(this.park);
      this.map.fitBounds(bounds, {
        padding: 20
      });
    }
  }

  setupReports(reports) {
    if (reports) {
      if (this.map.getLayer('reports')) {
        this.map.removeLayer('reports');
      }
      if (this.map.getSource('reports')) {
        this.map.removeSource('reports');
      }
      this.map.addLayer({
        'id': 'reports',
        'type': 'symbol',
        'source': {
          'type': 'geojson',
          'data': {
            'type': 'FeatureCollection',
            'features': reports.map(report => {
              console.log(report.payload.doc.data());
              return {
                'type': 'Feature',
                'properties': {
                  'uid': report.payload.doc.id,
                  // 'external': l.providerTag,
                  // 'animal': l.animal.id,
                  // 'locationUpdate': l.location.updated
                },
                'geometry': {
                  'type': 'Point',
                  'coordinates': [
                    report.payload.doc.data().location.geopoint.longitude,
                    report.payload.doc.data().location.geopoint.latitude
                  ]
                }
              };
            })
          }
        },
        'layout': {
          'icon-image': 'pulsing-dot-report',
          'icon-allow-overlap': true
        }
      });
    }
  }

  setupRangers(rangers) {
    if (rangers) {
      if (this.map.getLayer('rangers')) {
        this.map.removeLayer('rangers');
      }
      if (this.map.getSource('rangers')) {
        this.map.removeSource('rangers');
      }
      this.map.addLayer({
        'id': 'rangers',
        'type': 'symbol',
        'source': {
          'type': 'geojson',
          'data': {
            'type': 'FeatureCollection',
            'features': rangers.map(ranger => {
              console.log(ranger);
              return {
                'type': 'Feature',
                'properties': {
                  'uid': ranger.id,
                  // 'external': l.providerTag,
                  // 'animal': l.animal.id,
                  // 'locationUpdate': l.location.updated
                },
                'geometry': {
                  'type': 'Point',
                  'coordinates': [
                    ranger.location.geopoint.longitude,
                    ranger.location.geopoint.latitude
                  ]
                }
              };
            })
          }
        },
        'layout': {
          'icon-image': 'pulsing-dot-ranger',
          'icon-allow-overlap': true
        }
      });
    }
  }

  setupMarkers(markers) {
    if (markers) {
      if (this.map.getLayer('markers')) {
        this.map.removeLayer('markers');
      }
      if (this.map.getSource('markers')) {
        this.map.removeSource('markers');
      }
      this.map.addLayer({
        'id': 'markers',
        'type': 'symbol',
        'source': {
          'type': 'geojson',
          'data': {
            'type': 'FeatureCollection',
            'features': markers.map(marker => {
              console.log(marker.payload.doc.data());
              return {
                'type': 'Feature',
                'properties': {
                  'uid': marker.payload.doc.id,
                  // 'external': l.providerTag,
                  // 'animal': l.animal.id,
                  // 'locationUpdate': l.location.updated
                },
                'geometry': {
                  'type': 'Point',
                  'coordinates': [
                    marker.payload.doc.data().location.geopoint.longitude,
                    marker.payload.doc.data().location.geopoint.latitude
                  ]
                }
              };
            })
          }
        },
        'layout': {
          'icon-image': 'pulsing-dot-marker',
          'icon-allow-overlap': true
        }
      });
    }
  }

  setupDots() {
    const localMap = this.map;
    const size = 100;

    this.pulsingDotReport = {
      width: size,
      height: size,
      data: new Uint8Array(size * size * 4),

      onAdd: function() {
        const canvas = document.createElement('canvas');
        canvas.width = this.width;
        canvas.height = this.height;
        this.context = canvas.getContext('2d');
      },

      render: function() {
        const duration = 1000;
        const t = (performance.now() % duration) / duration;

        const radius = size / 2 * 0.3;
        const outerRadius = size / 2 * 0.7 * t + radius;
        const context = this.context;

        // draw outer circle
        context.clearRect(0, 0, this.width, this.height);
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, outerRadius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(255, 200, 200,' + (1 - t) + ')';
        context.fill();

        // draw inner circle
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, radius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(227, 54, 54, 1)';
        context.strokeStyle = 'white';
        context.lineWidth = 2 + 4 * (1 - t);
        context.fill();
        context.stroke();

        // update this image's data with data from the canvas
        this.data = context.getImageData(0, 0, this.width, this.height).data;

        // keep the map repainting
        localMap.triggerRepaint();

        // return 'true' to let the map know that the image was updated
        return true;
      }
    };

    this.pulsingDotRanger = {
      width: size,
      height: size,
      data: new Uint8Array(size * size * 4),

      onAdd: function() {
        const canvas = document.createElement('canvas');
        canvas.width = this.width;
        canvas.height = this.height;
        this.context = canvas.getContext('2d');
      },

      render: function() {
        const duration = 1000;
        const t = (performance.now() % duration) / duration;

        const radius = size / 2 * 0.3;
        const outerRadius = size / 2 * 0.7 * t + radius;
        const context = this.context;

        // draw outer circle
        context.clearRect(0, 0, this.width, this.height);
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, outerRadius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(103, 245, 112,' + (1 - t) + ')';
        context.fill();

        // draw inner circle
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, radius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(0, 163, 11, 1)';
        context.strokeStyle = 'white';
        context.lineWidth = 2 + 4 * (1 - t);
        context.fill();
        context.stroke();

        // update this image's data with data from the canvas
        this.data = context.getImageData(0, 0, this.width, this.height).data;

        // keep the map repainting
        localMap.triggerRepaint();

        // return 'true' to let the map know that the image was updated
        return true;
      }
    };

    this.pulsingDotMarker = {
      width: size,
      height: size,
      data: new Uint8Array(size * size * 4),

      onAdd: function() {
        const canvas = document.createElement('canvas');
        canvas.width = this.width;
        canvas.height = this.height;
        this.context = canvas.getContext('2d');
      },

      render: function() {
        const duration = 1000;
        const t = (performance.now() % duration) / duration;

        const radius = size / 2 * 0.3;
        const outerRadius = size / 2 * 0.7 * t + radius;
        const context = this.context;

        // draw outer circle
        context.clearRect(0, 0, this.width, this.height);
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, outerRadius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(0, 10, 194, 0)';
        context.fill();

        // draw inner circle
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, radius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(0, 10, 194, 1)';
        context.strokeStyle = 'white';
        context.lineWidth = 2 + 4 * (1 - t);
        context.fill();
        context.stroke();

        // update this image's data with data from the canvas
        this.data = context.getImageData(0, 0, this.width, this.height).data;

        // keep the map repainting
        localMap.triggerRepaint();

        // return 'true' to let the map know that the image was updated
        return true;
      }
    };
  }

}
