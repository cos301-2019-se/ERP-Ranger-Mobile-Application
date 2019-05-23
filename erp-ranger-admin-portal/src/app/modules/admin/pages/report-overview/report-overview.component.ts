import { Component } from '@angular/core';
import { MouseEvent } from '@agm/core';

@Component({
  selector: 'app-report-overview',
  templateUrl: './report-overview.component.html',
  styleUrls: ['./report-overview.component.scss']
})
export class ReportOverviewComponent {

  // google maps zoom level
  zoom: number = 13;
  
  // initial center position for the map
  lat: number = -25.876910;
  lng: number = 28.273253;

  clickedMarker(label: string, index: number) {
    console.log(`clicked the marker: ${label || index}`)
  }
  
  mapClicked($event: MouseEvent) {
    this.markers.push({
      lat: $event.coords.lat,
      lng: $event.coords.lng,
      draggable: true
    });
  }
  
  markerDragEnd(m: marker, $event: MouseEvent) {
    console.log('dragEnd', m, $event);
  }
  
  markers: marker[] = [
	  {
		  lat: -25.885364,
		  lng: 28.275074,
		  label: 'A',
		  draggable: false
	  },
	  {
		  lat: -25.877703,
		  lng: 28.284860,
		  label: 'B',
		  draggable: false
	  },
	  {
		  lat: -25.868007,
		  lng: 28.270805,
		  label: 'C',
		  draggable: false
	  }
  ]
}

// just an interface for type safety.
interface marker {
	lat: number;
	lng: number;
	label?: string;
	draggable: boolean;
}

