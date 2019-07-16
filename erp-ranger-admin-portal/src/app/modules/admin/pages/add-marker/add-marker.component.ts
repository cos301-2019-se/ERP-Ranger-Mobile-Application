import { Component, OnInit } from '@angular/core';
import { MouseEvent } from '@agm/core';
import { AddMarkerService } from '../../services/add-marker.service';

@Component({
  selector: 'app-add-marker',
  templateUrl: './add-marker.component.html',
  styleUrls: ['./add-marker.component.scss']
})
export class AddMarkerComponent implements OnInit {
  lat : number = 0;
  lng : number =0  
  zoom: number= 10;
  parkID : string = "";
  markerArr;

  

  currentMarker: number = 0;

  
  setRietvlei()  {
    this.lat = -25.884648;
    this.lng = 28.295682; 
    this.parkID = "iwGnWNuDC3m1hRzNNBT5";
    this.zoom = 12;
  }

  setOP(){
    this.lat = -26.884648;
    this.lng = 28.295682; 
  }

  setHighMarker(numberNew: string){
    if (parseInt(numberNew,10) >= this.currentMarker){
      this.currentMarker = parseInt(numberNew,10)+1;
      
    }
  }

  clickedMarker(label: string, index: number){
    
  }

  

  mapClicked($event: MouseEvent){
    let tempLat: number = $event.coords.lat;
    let tempLong : number = $event.coords.lng;
    this.addMarker(tempLat,tempLong);
    this.getMarkers();
  }
  constructor(private markers : AddMarkerService) { }

  ngOnInit() {
    this.getMarkers();
    this.setRietvlei();
  }
  addMarker(la : number,lo : number){
    var name = prompt("Marker Name:");
    this.markers.addMarker(this.currentMarker+"", la,lo, name, this.parkID);
    this.currentMarker++;
  }
  getMarkers(){
    this.markers.getMarkers().subscribe(result => {
      this.markerArr = result;
    });
  }

}


