import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { query } from '@angular/animations';

@Injectable({
  providedIn: 'root'
})
export class ReportReceiversService {

  constructor(private fireStore: AngularFirestore) { }

  addReportReceiver(data) {
    return this.fireStore.collection('report_type_park_user').add(data);
  }

  getReportReceivers(park?) {
    return this.fireStore.collection('report_type_park_user', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (park) {
        query = query.where('park', '==', park);
      }
      return query;
    }).snapshotChanges();
  }

  readReportReceiver(id) {
    return this.fireStore.doc('report_type_park_user/' + id).snapshotChanges();
  }

  deleteReportReceiver(id) {
    return this.fireStore.doc('report_type_park_user/' + id).delete();
  }

}
