import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { User } from '../models/User.model';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private fireStore: AngularFirestore) { }

  getUser(uid: String) {
    return this.fireStore.doc<User>(`users/${uid}`).snapshotChanges();
  }

  setUser(uid:string, email:String, name:String, number: String, active:boolean, role: String ){
    this.fireStore.collection("users").doc(uid).set({
      active: active,
      email: email,
      name: name,
      number:number,
      role: role,
      uid: uid
    })
  }

  getUserByID(uid: string) {
    let doc = this.fireStore.collection("users").doc(uid);
  }

  getUsers(){
    return this.fireStore.collection("users");
  }

  getUserLeaderboardData() {
    return this.fireStore.collection("users").snapshotChanges();
  }

}
