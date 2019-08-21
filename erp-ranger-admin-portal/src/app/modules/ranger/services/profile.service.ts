import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ProfileService {

  constructor(private fireStore: AngularFirestore) { }

  getUserName(id: string) {
    var docRef = this.fireStore.collection("users").doc(id).ref;
    return docRef;
  }

  // Get all user data based on specific id
  getUserDetails(id: string) {
    return this.fireStore.collection('users').doc(id).valueChanges();
  }
}
