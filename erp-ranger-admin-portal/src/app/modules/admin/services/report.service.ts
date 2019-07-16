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

  readReport(id: string) {
    //return this.fireStore.doc('reports/' + id).snapshotChanges();
    return this.fireStore.collection('reports').doc(id).valueChanges();
  }

}
