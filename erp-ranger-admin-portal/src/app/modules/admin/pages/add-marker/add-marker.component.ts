import {
  Component,
  OnInit
} from '@angular/core';
import {
  MouseEvent
} from '@agm/core';
import {
  AddMarkerService
} from '../../services/add-marker.service';
import { Park } from 'src/app/models/Park.model';
import { ParkService } from 'src/app/services/park.service';

@Component({
  selector: 'app-add-marker',
  templateUrl: './add-marker.component.html',
  styleUrls: ['./add-marker.component.scss']
})
export class AddMarkerComponent implements OnInit {
  lat: number = 0;
  lng: number = 0
  zoom: number = 10;
  parkID: string = "";
  markerArr;
  kml = 'https://gist.githubusercontent.com/Jtfnel/77b53014741ec9fce2ffc68d210cdf56/raw/cd8d5bbf2476c48512cb6d44694a52289aa52999/rietvlei.kml';
  defaultui;
  park: Park;

  currentMarker: number = 0;


  //set the default view
  setRietvlei() {
      this.lat = -25.884648;
      this.lng = 28.295682;
      this.parkID = "iwGnWNuDC3m1hRzNNBT5";
      this.zoom = 12;
  }

  //makes the mao full-screen
  setSize() {
      document.getElementById("map-agm").style.height = (document.body.offsetHeight - 32) + "px";
  }

  //Sets the id of a marker
  setIDMarker(numberNew: string) {
      if (parseInt(numberNew, 10) >= this.currentMarker) {
          this.currentMarker = parseInt(numberNew, 10) + 1;

      }
  }

  clickedMarker(label: string, index: number) {

  }


  //adds a marker on the spot clicked on the map
  mapClicked($event: MouseEvent) {
      let tempLat: number = $event.coords.lat;
      let tempLong: number = $event.coords.lng;
      this.addMarker(tempLat, tempLong);
      this.getMarkers();
  }
  constructor(private markers: AddMarkerService, private parkService: ParkService) {}

  ngOnInit() {
      this.park = this.parkService.getParkLocal();
      this.getMarkers();
      this.setRietvlei();
      // this.setSize();
  }

  createMarker(event) {
    this.addMarker(event.lngLat.lat, event.lngLat.lng);
  }

  //Asks for a name of the marker to create
  addMarker(la: number, lo: number) {
      var name = prompt("Marker Name:");
      if(name!="" && name !=null){
        this.markers.addMarker(this.currentMarker + "", la, lo, name, this.parkID);
        this.currentMarker++;
      }
  }

  //fetches all existing markers
  getMarkers() {
      this.markers.getMarkers().subscribe(result => {
          this.markerArr = result;
      });
  }

}
