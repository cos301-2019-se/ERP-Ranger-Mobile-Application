import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ParkService {

  constructor(private fireStore: AngularFirestore) { }

  addPark(data) {
    return this.fireStore.collection('parks').add(data);
  }

  getParks() {
    return this.fireStore.collection('parks').snapshotChanges();
  }

  readPark(id) {
    return this.fireStore.doc('parks/' + id).snapshotChanges();
  }

}
