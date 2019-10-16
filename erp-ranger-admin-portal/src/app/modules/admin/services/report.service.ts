import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ReportService {

  constructor(private fireStore: AngularFirestore) { }

  getAllReports(){
    return this.fireStore.collection('reports');
  }

  getReports(parkID?: string, handled?: boolean, limit?: number) {
    return this.fireStore.collection('reports', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (parkID) {
        query = query.where('park', '==', parkID);
      }
      if (typeof handled !== 'undefined') {
        query = query.where('handled', '==', handled);
      }
      if (limit) {
        query = query.limit(limit);
      }
      return query;
    }).snapshotChanges();
  }

  readReport(id: string) {
    //return this.fireStore.doc('reports/' + id).snapshotChanges();
    return this.fireStore.collection('reports').doc(id).valueChanges();
  }

  closeReport(id: string) {
    return this.fireStore.collection('reports').doc(id).update({
      handled: true
    });
  }

}
