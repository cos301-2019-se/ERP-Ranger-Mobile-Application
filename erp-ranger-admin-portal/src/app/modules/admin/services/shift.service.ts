import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { stringToKeyValue } from '@angular/flex-layout/extended/typings/style/style-transforms';

@Injectable({
  providedIn: 'root'
})
export class ShiftService {
 
  constructor(private fireStore: AngularFirestore) { }
  
  //Returns all shifts
  getShifts(){
    return this.fireStore.collection("shifts");
  }

  //returns a patrol with a specific ID
  getPatrol(id : string){
    
    return this.fireStore.collection("patrol").doc(id).ref;
  }

  //Returns all feedback 
  getFeedback(){
    return this.fireStore.collection("feedback");
  }

  //returns feedback for a specific ID
  getFeedbackID(id: string){
    return this.fireStore.collection("feedback").doc(id).ref;
  }

  //Fetches a user reference based on his/her id
  getUserName(id : string ){    
    var docRef = this.fireStore.collection("users").doc(id).ref;
    return docRef;    
  }

  //fetches a park based on its id
  getParkName(id : string ){    
    var docRef = this.fireStore.collection("parks").doc(id).ref;
    return docRef;    
  }
}
