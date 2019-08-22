import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ParkService {

  constructor(private fireStore: AngularFirestore) { }

  /*addPark(data) {
    return this.fireStore.collection('parks').add(data);
  }*/

  /**
   * Get a list of all the parks being manager by ERP
   */
  getParks() {
    return this.fireStore.collection('parks').snapshotChanges();
  }

  /**
   * Get a single park
   */
  readPark(id) {
    return this.fireStore.doc('parks/' + id).snapshotChanges();
  }

}
