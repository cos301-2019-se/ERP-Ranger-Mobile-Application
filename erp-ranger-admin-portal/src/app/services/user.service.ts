import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { AngularFireAuth } from '@angular/fire/auth';
import { User } from '../models/User.model';
import * as firebase from 'firebase';



@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private fireStore: AngularFirestore,private fireAuth: AngularFireAuth) { }

  getUser(uid: String) {
    return this.fireStore.doc<User>(`users/${uid}`).snapshotChanges();
  }

  setUser(uid:string, email:String, name:String, number: String, active:boolean, role: String, points=-1, remaining=-1){
    if (points== -1 || remaining == -1){
      this.fireStore.collection("users").doc(uid).update({
        active: active,
        email: email,
        name: name,
        number:number,
        role: role,
        uid: uid
    });
    }
    else{
      this.fireStore.collection("users").doc(uid).set({
        active: active,
        email: email,
        name: name,
        number:number,
        role: role,
        points: parseInt(points+ "",10),
        remaining: parseInt(remaining+ "",10),
        uid: uid
      })
    }

    
    // this.fireStore.collection("users").doc(uid).set({
    //   active: active,
    //   email: email,
    //   name: name,
    //   number:number,
    //   role: role,
    //   points: parseInt(points+ "",10),
    //   uid: uid
    // })
  }


  getUserByID(uid: string) {
    let doc = this.fireStore.collection("users").doc(uid);
  }


  // Get all users stored in the database
  getUsers(){
    return this.fireStore.collection("users");
  }

  deleteUser(id : string){
    this.fireStore.collection("users").doc(id).update({
      active: false
    }).then(function(){
      location.reload();
    })
  }
     
  getUserLeaderboardData() {
    return this.fireStore.collection("users", ref => ref.orderBy("points")).valueChanges();
  }

  

}
