import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ReportService {

  constructor(private fireStore: AngularFirestore) { }

  getReports() {
    return this.fireStore.collection('reports').snapshotChanges();
  }

}
