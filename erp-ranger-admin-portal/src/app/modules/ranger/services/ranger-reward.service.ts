import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';

@Injectable({
  providedIn: 'root'
})
export class RangerRewardService {

  constructor(private fireStore: AngularFirestore, private storage: AngularFireStorage) { }

  // Get all rewards currently added to the database
  getRewards(){
    return this.fireStore.collection("rewards").snapshotChanges();
  }
}
