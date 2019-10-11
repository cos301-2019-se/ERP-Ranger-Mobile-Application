import { Component, OnInit, SystemJsNgModuleLoader } from '@angular/core';
import { PositionService } from '../../services/position.service';
import { PopupService } from '@ng-bootstrap/ng-bootstrap/util/popup';
import { latitude, longitude } from '@rxweb/reactive-form-validators';
import { PLATFORM_WORKER_UI_ID } from '@angular/common/src/platform_id';
import { ShiftService} from '../../services/shift.service';
import { removeSummaryDuplicates } from '@angular/compiler';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-user-positions',
  templateUrl: './user-positions.component.html',
  styleUrls: ['./user-positions.component.scss']
})




export class UserPositionsComponent implements OnInit {
  riet;
  rangerList;
  userList;
  lat : number = 0;
  lng : number =0
  zoom: number= 12;
  parkID="";
  resetTime : number = 60;
  kml = 'https://gist.githubusercontent.com/Jtfnel/77b53014741ec9fce2ffc68d210cdf56/raw/cd8d5bbf2476c48512cb6d44694a52289aa52999/rietvlei.kml';
  defaultui;
  posArr: posMarker[] = [];
  constructor(private pService : PositionService, private shifts : ShiftService, private userService: UserService) { }

  ngOnInit() {
    this.riet = {
      id: '80a612fd-1e2f-4511-8a4a-2d9a87ae4ca5',
      created: 1577905200000,
      updated: 1577905200000,
      name: 'Rietvlei',
      fence: {
        geoJson: {
          type: 'Polygon',
          coordinates: [
            [
              [-25.846247, 28.28001],
              [-25.851809, 28.291168],
              [-25.855207, 28.296661],
              [-25.860305, 28.300953],
              [-25.868646, 28.306618],
              [-25.8766775, 28.312626],
              [-25.886099, 28.320179],
              [-25.892739, 28.323784],
              [-25.903086, 28.325157],
              [-25.913277, 28.3244705],
              [-25.914048, 28.307991],
              [-25.92007, 28.307304],
              [-25.931649, 28.304558],
              [-25.934582, 28.302841],
              [-25.936744, 28.299923],
              [-25.936744, 28.296318],
              [-25.931958, 28.273144],
              [-25.92393, 28.278122],
              [-25.92393, 28.28207],
              [-25.91513, 28.281727],
              [-25.915439, 28.276234],
              [-25.902622, 28.273487],
              [-25.903857, 28.266277],
              [-25.867256, 28.262329],
              [-25.858605, 28.269196],
              [-25.8527355, 28.272972],
              [-25.846247, 28.28001]
            ]
          ]
        }
      }
    };
    // this.setSize();
    // this.setRietvlei();
    this.getPositions();
    this.displayPositions();
    setTimeout(function(){
      this.posArr = this.posArr;
    },1900);
    setInterval(function(){
      this.posArr = this.posArr;
    },3500)
    // setInterval(()=> {
    //   this.refreshArray(); },this.resetTime * 1000);



  }
  refreshArray(){
    this.posArr = this.posArr;

  }
  setSize(){
    document.getElementById("map-agm").style.height = (document.body.offsetHeight - 32) + "px";
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
        this.posArr.splice(i,1);
      }
      i++;
    }


  }

  arrayContains(uid : String) : boolean{
    var i = 0;
    var found = false;
      while(i<this.posArr.length && !found){
        if(this.posArr[i].userID == uid){
          found = true;
        }
        i++;
      }
      return found;

  }

  mapClicked($event: MouseEvent){

  }
  arrContains(uid:String): boolean{
    var contains = false;
    var i = 0;
    while(i< this.posArr.length){
      if(this.posArr[i].userID == uid){
        contains = true;
        i=this.posArr.length;
      }
      i++;
    }

    return contains;
  }
  removeDatesWithID(d : Date, uid : String) : boolean{
    var i = 0;
    var done = false;
    if(this.posArr.length <1 || !(this.arrContains(uid))){
      done = true;
      i = this.posArr.length;
    }
      while(i<this.posArr.length){
       if(this.posArr[i].userID == uid && d.getTime() > this.posArr[i].time.getDate()){

          this.posArr.splice(i,1);

          done = true;

        }
        i++;
      }
    return done;

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
        if(nameID==null){

        }
        else{
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

                if(this.removeDatesWithID(temp, nameID))
                {


                  this.posArr = [...this.posArr,{
                    id:change.doc.id,
                    latitude: change.doc.data().location.geopoint.latitude,
                    longitude:change.doc.data().location.geopoint.longitude,
                    parkName: docPark.data().name,
                    userID:nameID,
                    userName: doc.data().name,
                    time: temp,
                    icon : {
                      url: 'https://fonts.gstatic.com/s/i/materialicons/my_location/v1/24px.svg',
                      scaledSize: {
                        width: 30,
                        height: 30
                      }
                    }

                  }];
                  this.posArr =this.posArr;

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


      }})
    })
  }

  displayPositions() {
    this.pService.getPositions().snapshotChanges().subscribe((results) => {
      const temp = [];
      this.rangerList = [];
      for (let i = 0; i < results.length; i++) {
        const data = results[i].payload.doc.data();
        if (
          (
            data['user'] != null
          ) &&
          (
            (!temp[data['user']]) ||
            (temp[data['user']]['time'].toMillis() < data['time'].toMillis())
          )
        ) {
          temp[data['user']] = data;
        }
      }
      for (const element in temp) {
        if (temp.hasOwnProperty(element)) {
          const data = temp[element];
          data['id'] = element;
          this.rangerList.push(data);
        }
      }
      this.getUsers();
    });
  }

  getUsers() {
    this.userList = [];
    for (let i = 0; i < this.rangerList.length; i++) {
      this.userService.getUser(this.rangerList[i]['id']).subscribe((result) => {
        const data = [];
        data['id'] = String(result.payload.id);
        data['name'] = String(result.payload.data()['name']);
        data['number'] = String(result.payload.data()['number']);
        data['email'] = String(result.payload.data()['email']);
        this.userList.push(data);
        for (let j = 0; j < this.rangerList.length; j++) {
          if (this.rangerList[j]['user'] === data['id']) {
            this.rangerList[j]['ranger'] = data;
          }
        }
      });
    }
  }

}

interface posMarker{
  id:string,
  latitude: number,
  longitude:number,
  parkName: string,
  userID:string,
  icon?,
  userName: string,
  time: Date
}
