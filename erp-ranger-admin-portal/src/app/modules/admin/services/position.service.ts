import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { stringToKeyValue } from '@angular/flex-layout/extended/typings/style/style-transforms';
import * as firebase from 'firebase/app'


@Injectable({
  providedIn: 'root'
})
export class PositionService {

  constructor(private fireStore: AngularFirestore) { }

  //fetches positions of users
  getPositions(parkID?: string) {
    return this.fireStore.collection('position', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (parkID) {
        query = query.where('park', '==', parkID);
      }
      return query;
    });
  }

}
