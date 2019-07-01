import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/auth';
import { AngularFirestore, AngularFirestoreDocument } from '@angular/fire/firestore';
import { Observable, of } from 'rxjs';
import { User } from '../../../models/User.model';
import { UserService } from '../../../services/user.service';
import { resolve } from 'dns';
import { reject } from 'q';

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
      return new Promise ((resolve, reject) =>{
        this.fireAuth.auth.createUserWithEmailAndPassword(email,password)
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
          })
        });
  
    });
  }
     
}
