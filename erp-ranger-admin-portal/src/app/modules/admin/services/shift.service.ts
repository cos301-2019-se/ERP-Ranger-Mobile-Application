import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { stringToKeyValue } from '@angular/flex-layout/extended/typings/style/style-transforms';

@Injectable({
  providedIn: 'root'
})
export class ShiftService {
 
  constructor(private fireStore: AngularFirestore) { }
  
  getShifts(){
    return this.fireStore.collection("shifts");
  }


  getPatrol(id : string){
    
    return this.fireStore.collection("patrol").doc(id).ref;
  }

  getFeedback(){
    return this.fireStore.collection("feedback");
  }
  
  getFeedbackID(id: string){
    return this.fireStore.collection("feedback").doc(id).ref;
  }


  getUserName(id : string ){    
    var docRef = this.fireStore.collection("users").doc(id).ref;
    return docRef;    
  }

  getParkName(id : string ){    
    var docRef = this.fireStore.collection("parks").doc(id).ref;
    return docRef;    
  }
}
