import { Component, OnInit, Input, AfterViewInit, OnChanges, SimpleChange, Output, EventEmitter, ViewEncapsulation } from '@angular/core';
import * as mapboxgl from 'mapbox-gl';
import { Park } from 'src/app/models/Park.model';
import { environment } from 'src/environments/environment';
import { Color } from 'src/app/models/Color.model';

@Component({
  selector: 'app-park-map',
  templateUrl: './park-map.component.html',
  styleUrls: ['./park-map.component.scss'],
  encapsulation: ViewEncapsulation.None
})
export class ParkMapComponent implements OnInit, AfterViewInit, OnChanges {
  @Input() park: Park;
  @Input() parks: Park[];
  @Input() markers;
  @Input() rangers;
  @Input() reports;
  @Input() report;
  @Input() fixed: boolean;
  @Input() center;
  @Input() zoom = 10;
  @Input() createMarkers = false;
  // tslint:disable-next-line: no-output-on-prefix
  @Output() onCreateMarker: EventEmitter<any> = new EventEmitter<any>();

  storedChanges: SimpleChange;
  create: Boolean;

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
    if (this.createMarkers) {
      this.rangers = null;
      this.reports = null;
      this.report = null;
      this.setupMarkerCreationMode(this.createMarkers);
    }
    this.buildMapBase();
  }

  ngOnChanges(changes: any) {
    if (this.map) {
      if (changes['reports'] && (changes['reports'].currentValue !== changes['reports'].previousValue)) {
        this.setupReports(changes['reports'].currentValue);
      }
      if (changes['report'] && (changes['report'].currentValue !== changes['report'].previousValue)) {
        this.setupReport(changes['report'].currentValue);
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
      if (changes['park'] && (changes['park'].currentValue !== changes['park'].previousValue)) {
        this.setupPark(changes['park'].currentValue);
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
    if (this.center) {
      center = [
        this.center.longitude,
        this.center.latitude
      ];
    } else if (this.park) {
      center = [
        this.park.fence.geoJson.coordinates[0][0][0],
        this.park.fence.geoJson.coordinates[0][0][1]
      ];
    } else {
      center = [ // EPI Use Africa Menlyn Office
        28.278051304132134,
        -25.77998666415725
      ];
    }
    this.map = new mapboxgl.Map({
      container: 'map',
      // style: 'mapbox://styles/mapbox/streets-v11',
      // style: 'mapbox://styles/erp-rangers/ck11chqnc0eds1cugiybx7eyl',
      style: 'mapbox://styles/erpngo/ck1j6095i5t301conykwr63dl',
      center: center,
      zoom: this.zoom
    });
    this.setupDots();
    if (this.storedChanges) {
      // this.ngOnChanges(this.storedChanges);
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
        this.setupPark(this.park);
        this.zoomToPark();
      } else if (this.parks) {

      }

      // Display reports in a park
      this.setupReports(this.reports);

      // Display rangers in a park
      this.setupRangers(this.rangers);

      // Display markers in a park
      this.setupMarkers(this.markers);

      // Display report in a park
      this.setupReport(this.report);

      this.mapRefresh();

    });
  }

  changeMarkerCreationMode() {
    this.create = !this.create;
  }

  setupMarkerCreationMode(createMarkers) {
    if (this.createMarkers) {
      this.map.on('click', (e) => {
        if (this.create) {
          this.onCreateMarker.emit(e);
        }
      });
    }
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

  closePopups() {
    const popUps = document.getElementsByClassName('mapboxgl-popup');
    if (popUps[0]) {
      popUps[0].remove();
    }
  }

  setupPark(park) {
    if (park && this.map) {
      if (this.map.getLayer('park')) {
        this.map.removeLayer('park');
      }
      if (this.map.getSource('park')) {
        this.map.removeSource('park');
      }
      this.map.addLayer({
        'id': 'park',
        'type': 'fill',
        'source': {
          'type': 'geojson',
          'data': {
            'type': 'Feature',
            'geometry': {
              'type': park.fence.geoJson.type,
              'coordinates': park.fence.geoJson.coordinates
            }
          }
        },
        'layout': {},
        'paint': {
          'fill-color': '#9ff74d',
          'fill-opacity': 0.2
        }
      });
    }
  }

  setupReports(reports) {
    if (reports && this.map) {
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
              return {
                'type': 'Feature',
                'properties': {
                  'id': report.payload.doc.id,
                  'type': report.payload.doc.data().type,
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

      this.map.on('click', 'reports', (e) => {
        this.closePopups();
        const coordinates = e.features[0].geometry.coordinates.slice();
        let description = '<h2>Report: ' + e.features[0].properties.type + '</h2>';
        description += '<a href="/admin/report/' + e.features[0].properties.id + '">';
        description += '<button id="popup-button" color="primary" class="mat-raised-button">Open Report</button>';
        description += '</a>';

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }

        const popup = new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(description)
          .addTo(this.map);
      });

      // Change the cursor to a pointer when the mouse is over the places layer.
      this.map.on('mouseenter', 'reports', () => {
        this.map.getCanvas().style.cursor = 'pointer';
      });

      // Change it back to a pointer when it leaves.
      this.map.on('mouseleave', 'reports', () => {
        this.map.getCanvas().style.cursor = '';
      });
    }
  }

  setupReport(report) {
    if (report && this.map) {
      if (this.map.getLayer('report')) {
        this.map.removeLayer('report');
      }
      if (this.map.getSource('report')) {
        this.map.removeSource('report');
      }
      this.map.addLayer({
        'id': 'report',
        'type': 'symbol',
        'source': {
          'type': 'geojson',
          'data': {
            'type': 'FeatureCollection',
            'features': [{
              'type': 'Feature',
              'properties': {
                'id': report
              },
              'geometry': {
                'type': 'Point',
                'coordinates': [
                  report.location.geopoint.longitude,
                  report.location.geopoint.latitude
                ]
              }
            }]
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
    if (rangers && this.map) {
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
              return {
                'type': 'Feature',
                'properties': {
                  'id': ranger.id,
                  'name': ranger.ranger.name,
                  'number': ranger.ranger.number
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

      this.map.on('click', 'rangers', (e) => {
        this.closePopups();
        const coordinates = e.features[0].geometry.coordinates.slice();
        let description = '<h2>Ranger: ' + e.features[0].properties.name + '</h2>';
        description += '<h4>Number: ' + e.features[0].properties.number + '</h4>';

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }

        const popup = new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(description)
          .addTo(this.map);
      });

      // Change the cursor to a pointer when the mouse is over the places layer.
      this.map.on('mouseenter', 'rangers', () => {
        this.map.getCanvas().style.cursor = 'pointer';
      });

      // Change it back to a pointer when it leaves.
      this.map.on('mouseleave', 'rangers', () => {
        this.map.getCanvas().style.cursor = '';
      });
    }
  }

  setupMarkers(markers) {
    if (markers && this.map) {
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
                  'id': marker.payload.doc.id,
                  'name': marker.payload.doc.data().name,
                  'points': marker.payload.doc.data().points
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

      this.map.on('click', 'markers', (e) => {
        if (this.create) {
          return;
        }
        this.closePopups();
        const coordinates = e.features[0].geometry.coordinates.slice();
        let description = '<h2>Marker: ' + e.features[0].properties.name + '</h2>';
        description += '<h3>Points: ' + e.features[0].properties.points + '</h3>';

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }

        const popup = new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(description)
          .addTo(this.map);
      });

      // Change the cursor to a pointer when the mouse is over the places layer.
      this.map.on('mouseenter', 'markers', () => {
        this.map.getCanvas().style.cursor = 'pointer';
      });

      // Change it back to a pointer when it leaves.
      this.map.on('mouseleave', 'markers', () => {
        this.map.getCanvas().style.cursor = '';
      });
    }
  }

  setupDots() {
    this.pulsingDotReport = this.createDot(
      this.map,
      115,
      { red: 255, green: 200, blue: 200 },
      { red: 227, green: 54, blue: 54 },
      true
    );

    this.pulsingDotRanger = this.createDot(
      this.map,
      110,
      { red: 103, green: 245, blue: 112 },
      { red: 0, green: 163, blue: 11 },
      true
    );

    this.pulsingDotMarker = this.createDot(
      this.map,
      100,
      { red: 0, green: 10, blue: 194 },
      { red: 0, green: 10, blue: 194 },
      false
    );
  }

  createDot(map, size, outer: Color, inner: Color, pulse: Boolean) {
    return {
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
        if (pulse) {
          context.clearRect(0, 0, this.width, this.height);
          context.beginPath();
          context.arc(this.width / 2, this.height / 2, outerRadius, 0, Math.PI * 2);
          context.fillStyle = 'rgba(' + outer.red + ',' + outer.green + ',' + outer.blue + ',' + (1 - t) + ')';
          context.fill();
        }

        // draw inner circle
        context.beginPath();
        context.arc(this.width / 2, this.height / 2, radius, 0, Math.PI * 2);
        context.fillStyle = 'rgba(' + inner.red + ',' + inner.green + ',' + inner.blue + ',1)';
        context.strokeStyle = 'white';
        if (pulse) {
          context.lineWidth = 2 + 4 * (1 - t);
        } else {
          context.lineWidth = 2 + 4 * 1;
        }
        context.fill();
        context.stroke();

        // update this image's data with data from the canvas
        this.data = context.getImageData(0, 0, this.width, this.height).data;

        // keep the map repainting
        map.triggerRepaint();

        // return 'true' to let the map know that the image was updated
        return true;
      }
    };
  }

}
