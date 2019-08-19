import { Component, OnInit, Inject } from '@angular/core';
import { ReportTypeService } from '../../services/report-type.service';
import { ReportType } from 'src/app/models/ReportType.model';
import { MatTableDataSource } from '@angular/material/table';
import { ReportReceiversService } from '../../services/report-receivers.service';

@Component({
  selector: 'app-notification-list',
  templateUrl: './notification-list.component.html',
  styleUrls: ['./notification-list.component.scss']
})
export class NotificationListComponent implements OnInit {

  displayedColumns: string[] = ['importance', 'type', 'sms', 'email', 'web', 'api', 'edit'];
  reportTypes: ReportType[] = [];
  reportReceivers = [];
  dataSource = new MatTableDataSource(this.reportTypes);
  dataSourceReceivers = new MatTableDataSource(this.reportReceivers);

  constructor(
    private reportTypeService: ReportTypeService,
    private reportReceiverService: ReportReceiversService
  ) { }

  ngOnInit() {
    this.getReportTypes();
    this.getReportReceivers();
  }

  getReportTypes() {
    this.reportTypeService.getReportTypes().subscribe((result) => {
      this.reportTypes = [];
      for (let i = 0; i < result.length; i++) {
        this.reportTypes[i] = {
          id: String(result[i].payload.doc.id),
          importance: String(result[i].payload.doc.data()['importance']),
          methods: result[i].payload.doc.data()['methods'],
          type: String(result[i].payload.doc.data()['type'])
        };
      }
      this.dataSource = new MatTableDataSource(this.reportTypes);
    });
  }

  deleteReportType(id) {
    let type;
    for (let i = 0; i < this.reportTypes.length; i++) {
      if (this.reportTypes[i].id === id) {
        type = this.reportTypes[i];
        break;
      }
    }
    if (confirm('Do you want to delete the "' + type.type + '" report type?')) {
      this.reportTypeService.deleteReportType(id)
        .then(() => {
          alert('Successfully deleted the "' + type.type + '" report type!');
        })
        .catch(() => {
          alert('Failed to delete the "' + type.type + '" report type!');
        });
    }
  }

  getReportReceivers() {
    this.reportReceiverService.getReportTypes().subscribe((results) => {
      console.log(results);
      this.reportTypes = [];
      for (let i = 0; i < results.length; i++) {
        console.log(results[i].payload.doc.data()['user_name']);
        console.log(results[i].payload.doc.data()['park_name']);
        const id = results[i].payload.doc.id;
        this.reportTypeService.readReportType(results[i].payload.doc.id).subscribe((results) => {
          console.log(id);
          console.log(results);
        });
        /*this.reportTypes[i] = {
          id: String(result[i].payload.doc.id),
          importance: String(result[i].payload.doc.data()['importance']),
          methods: result[i].payload.doc.data()['methods'],
          type: String(result[i].payload.doc.data()['type'])
        };*/
      }
      this.dataSourceReceivers = new MatTableDataSource(this.reportReceivers);
    });
  }

}
