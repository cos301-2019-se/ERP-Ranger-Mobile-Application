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
    var self = this;
    this.fireStore.collection('markers').add({
      active: true,
      id: "",
      location : {
        geopoint: locationData
          
        
      },
      name: name,
      park: park,
      points : 1000,


    }).then(function(docRef){
      
      self.fireStore.collection('markers').doc(docRef.id).set({
        id: docRef.id,
        name: name,
        park: park,
        points : 200,
        active:true,
        location : {
          geopoint: locationData         
        },
      })
    })

  }
}
