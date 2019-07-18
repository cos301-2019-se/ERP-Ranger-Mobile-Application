import { Component, OnInit } from '@angular/core';
import { PositionService } from '../../services/position.service';
import { PopupService } from '@ng-bootstrap/ng-bootstrap/util/popup';
import { latitude, longitude } from '@rxweb/reactive-form-validators';
import { PLATFORM_WORKER_UI_ID } from '@angular/common/src/platform_id';
import { ShiftService} from '../../services/shift.service';

@Component({
  selector: 'app-user-positions',
  templateUrl: './user-positions.component.html',
  styleUrls: ['./user-positions.component.scss']
})
export class UserPositionsComponent implements OnInit {
  lat : number = 0;
  lng : number =0  
  zoom: number= 12;
  parkID="";
  resetTime : number = 60;
  
  posArr: posMarker[] = [];
  constructor(private pService : PositionService, private shifts : ShiftService) { }

  ngOnInit() {
    this.setSize();
    this.setRietvlei();
    this.getPositions();
    setTimeout(function(){
      this.posArr = this.posArr;
    },1900);
    setInterval(()=> {
      this.clearArray(); },this.resetTime * 1000); 
      this.posArr = this.posArr;
    
    
  }
  clearArray(){
    
    var now = new Date();
    for(var i =0;i<this.posArr.length;i++){
      if((now.getTime() - this.posArr[i].time.getTime()) > (this.resetTime * 1000))
      {
        this.posArr.splice(i);
        i--;
      }
    }
  }
  setSize(){
    document.getElementById("map-agm").style.height = (document.body.offsetHeight - 96) + "px";
  }
  setRietvlei()  {
    this.lat = -25.884648;
    this.lng = 28.295682; 
    this.parkID = "iwGnWNuDC3m1hRzNNBT5";
    this.zoom = 11;
  }
  hasPos(id:string):boolean{
    var hasVal : boolean;
    hasVal = false;
    for(var i = 0;i<this.posArr.length;i++){
      if(this.posArr[i].id == id){
        hasVal = true;
        i = this.posArr.length;
      }
    }

    return hasVal

  }
  deleteById(id:string){
    var deleted = false;
    var i = 0;
    while (!deleted){
      if(this.posArr[i].id == id){
        deleted = true;
        this.posArr.splice(i);        
      }
      i++;
    }

    
  }
  mapClicked($event: MouseEvent){
    
  }
  getPositions(){
    var self = this;
    let observer = this.pService.getPositions().ref
    .onSnapshot(querySnapshot => {
        querySnapshot.docChanges().forEach(change => {
        if(this.hasPos(change.doc.id)){
          this.deleteById(change.doc.id);
        }
        var nameID = change.doc.data().user;
        var parkID = change.doc.data().park;

        let docRef = this.shifts.getUserName(nameID);     
        let getUser = docRef.get()
        .then(doc => {
          if(!doc.exists){
            console.log("User not found : " + nameID);
            
          } else{
            
            let parkRef = this.shifts.getParkName(parkID);
            let getPark = parkRef.get()
            .then(docPark => {
              if(!docPark.exists){
                console.log("Park not found ");                
              }
              else{
                
                var temp  : Date;
                temp = change.doc.data().time.toDate();
                
                var now = new Date();
                if((now.getTime() - temp.getTime()) < (this.resetTime * 1000000000))
                {
                  this.posArr = [...this.posArr,{
                    id:change.doc.id,
                    latitude: change.doc.data().location.geopoint.latitude,
                    longitude:change.doc.data().location.geopoint.longitude,
                    parkName: docPark.data().name,
                    userName: doc.data().name,
                    time: temp
          
                  }];
                  console.log("Success");
                }
              }
            })  
            .catch(err => {
              console.log("Error getting document here");         
            })          
          }
        })
        .catch(err => {
          console.log("Error getting document "+ err);         
        });


      })
    })
  }
}

interface posMarker{
  id:string,
  latitude: number,
  longitude:number,
  parkName: string,
  userName: string,
  time: Date
}
