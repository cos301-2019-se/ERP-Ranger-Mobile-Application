import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ReportTypeService {

  constructor(private fireStore: AngularFirestore) { }

  /**
   * Add a new report type
   */
  addReportType(data) {
    return this.fireStore.collection('report_types').add(data);
  }

  /**
   * Get a list of all the report types
   */
  getReportTypes() {
    return this.fireStore.collection('report_types').snapshotChanges();
  }

  /**
   * Get a single report type
   */
  readReportType(id) {
    return this.fireStore.doc('report_types/' + id).snapshotChanges();
  }

  /**
   * Update a specific report type
   */
  updateReportType(id, data) {
    return this.fireStore.doc('report_types/' + id).update(data);
  }

  /**
   * Delete a specific report type
   */
  deleteReportType(id) {
    return this.fireStore.doc('report_types/' + id).delete();
  }

}
