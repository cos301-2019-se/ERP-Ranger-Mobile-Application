import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { query } from '@angular/animations';

@Injectable({
  providedIn: 'root'
})
export class ReportReceiversService {

  constructor(private fireStore: AngularFirestore) { }

  /**
   * Create a new report notification
   */
  addReportReceiver(data) {
    return this.fireStore.collection('report_type_park_user').add(data);
  }

  /**
   * Get a list of all the report notifications for a certain park
   */
  getReportReceivers(park?) {
    return this.fireStore.collection('report_type_park_user', (ref) => {
      let query: firebase.firestore.CollectionReference | firebase.firestore.Query = ref;
      if (park) {
        query = query.where('park', '==', park);
      }
      return query;
    }).snapshotChanges();
  }

  /**
   * Get a single report notification
   */
  readReportReceiver(id) {
    return this.fireStore.doc('report_type_park_user/' + id).snapshotChanges();
  }

  /**
   * Delete a report notification
   */
  deleteReportReceiver(id) {
    return this.fireStore.doc('report_type_park_user/' + id).delete();
  }

}
