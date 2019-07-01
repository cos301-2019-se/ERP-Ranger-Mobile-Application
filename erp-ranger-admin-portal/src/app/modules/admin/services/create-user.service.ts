import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/auth';
import { AngularFirestore, AngularFirestoreDocument } from '@angular/fire/firestore';
import { Observable, of } from 'rxjs';
import { User } from '../../../models/User.model';
import { UserService } from '../../../services/user.service';
import { resolve } from 'dns';
import { reject } from 'q';
import * as firebase from 'firebase';

@Injectable({
  providedIn: 'root'
})
export class CreateUserService {
  user : Observable< User | null>;

  constructor(
    private fireStore : AngularFirestore,
    private fireAuth: AngularFireAuth) {

  }

  register(email: string, password : string, name: string, number: string){  
    var config = {apiKey: "AIzaSyArcavcPL0-hdLcbknUGGx9xdX6NR1AJ0o",
        authDomain: "erp-ranger-app.firebaseapp.com",
        firebase_url: "https://erp-rangers-app.firebaseio.com"};    
    var secondaryApp = firebase.initializeApp(config, "Secondary");  
    return new Promise ((resolve, reject) =>{
      secondaryApp.auth().createUserWithEmailAndPassword(email,password)
      .then( (userData) => {resolve(userData), 
      err => reject(err) 
        return userData}) 
      .then( (userData) => {          
        this.fireStore.collection('users').doc(userData.user.uid).set({
          active: true,
          email: email,
          name: name,
          number:number,
          role: "Ranger",
          uid: userData.user.uid
        });
        secondaryApp.auth().signOut();
        firebase.app("Secondary").delete().then(function(){});
      });
    });
  
  }
     
}


