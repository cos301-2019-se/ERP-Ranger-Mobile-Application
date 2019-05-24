import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ShiftService {
 
  constructor(private fireStore: AngularFirestore) { }
  
  getShifts(){
    return this.fireStore.collection("shifts").snapshotChanges();
  }
}
