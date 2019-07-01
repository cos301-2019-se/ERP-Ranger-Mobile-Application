import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { stringToKeyValue } from '@angular/flex-layout/extended/typings/style/style-transforms';
import * as firebase from 'firebase/app'

@Injectable({
  providedIn: 'root'
})
export class AddMarkerService {

  constructor(private fireStore: AngularFirestore) { }

  getMarkers(){
    return this.fireStore.collection('markers').snapshotChanges();
  }

  addMarker(id: string, lat: number, long: number,name:string,park:string){
    var locationData = new firebase.firestore.GeoPoint(lat,long);
    return this.fireStore.collection('markers').add({
      active: true,
      id: id,
      location : {
        geopoint: locationData
          
        
      },
      name: name,
      park: park,
      points : 1000

    })

  }
}
