import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root'
})
export class ReportTypeService {

  constructor(private fireStore: AngularFirestore) { }

  addReportType(data) {
    return this.fireStore.collection('report_types').add(data);
  }

  getReportTypes() {
    return this.fireStore.collection('report_types').snapshotChanges();
  }

  readReportType(id) {
    return this.fireStore.doc('report_types/' + id).snapshotChanges();
  }

  updateReportType(id, data) {
    return this.fireStore.doc('report_types/' + id).update(data);
  }

  deleteReportType(id) {
    return this.fireStore.doc('report_types/' + id).delete();
  }

}
