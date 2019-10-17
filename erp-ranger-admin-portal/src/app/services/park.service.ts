import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { Park } from 'src/app/models/Park.model';

@Injectable({
  providedIn: 'root'
})
export class ParkService {

  constructor(private fireStore: AngularFirestore) { }

  /**
   * Get a list of all the parks being manager by ERP
   */
  getParks(limit?: number) {
    return this.fireStore.collection('parks', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (limit) {
        query = query.limit(limit);
      }
      return query;
    }).snapshotChanges();
  }

  /**
   * Get a single park
   */
  readPark(id) {
    return this.fireStore.doc('parks/' + id).snapshotChanges();
  }

  /**
   * Store a park in localstorage for quick access and usage
   */
  getParkLocal(): Park {
    if (localStorage.getItem('park') !== null) {
      return JSON.parse(localStorage.getItem('park'));
    } else {
      return null;
    }
  }

  /**
   * Set the current working park
   */
  setParkLocal(park) {
    localStorage.removeItem('park');
    localStorage.setItem('park', JSON.stringify(this.formatToParkModel(park)));
  }

  /**
   * Clear the current working park
   */
  deleteParkLocal() {
    localStorage.removeItem('park');
  }

  /**
   * Correct the format from Firestore
   */
  formatToParkModel(park): Park {
    if (park && park.fence) {
      const temp = [[]];
      park.fence.geoJson.coordinates.forEach(element => {
        temp[0].push([element.lat, element.lon]);
      });
      park.fence.geoJson.coordinates = temp;
    }
    return park;
  }

}
