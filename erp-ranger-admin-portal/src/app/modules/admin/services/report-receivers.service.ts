import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { query } from '@angular/animations';

@Injectable({
  providedIn: 'root'
})
export class ReportReceiversService {

  constructor(private fireStore: AngularFirestore) { }

  addReportType(data) {
    //return this.fireStore.collection('report_types').add(data);
  }

  getReportTypes(park?) {
    return this.fireStore.collection('report_type_park_user', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (park) {
        query = query.where('park', '==', park);
      }
      return query;
    }).snapshotChanges();
  }

  readReportType(id) {
    //return this.fireStore.doc('report_types/' + id).snapshotChanges();
  }

  updateReportType(id, data) {
    //return this.fireStore.doc('report_types/' + id).update(data);
  }

  deleteReportType(id) {
    //return this.fireStore.doc('report_types/' + id).delete();
  }

}
