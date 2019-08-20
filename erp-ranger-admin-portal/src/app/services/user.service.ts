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

  setUser(uid:string, email:String, name:String, number: String, active:boolean, role: String, points: String, remaining:string){
    this.fireStore.collection("users").doc(uid).update({
      active: active,
      email: email,
      name: name,
      number:number,
      role: role,
      points: parseInt(points+ "",10),
      remaining: parseInt(remaining+ "",10),
      uid: uid
    })
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

  getUsers(){
    return this.fireStore.collection("users");
  }

  deleteUser(id : string){
    this.fireStore.collection("users").doc(id).update({
      active: false
    })
  }
     

    // var user = admin.auth().deleteUser(id)
    // .then(function() {
    //   console.log('Successfully deleted user');
    // })
    // .catch(function(error) {
    //   console.log('Error deleting user:', error);
    // });

  

}
