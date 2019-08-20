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


  // Get all users stored in the database
  getUsers(){
    return this.fireStore.collection("users");
  }


  // Get all users from the database and sort the result according to points earned by each ranger
  getUserLeaderboardData() {
    return this.fireStore.collection("users", ref => ref.orderBy("points")).valueChanges();
  }

}
