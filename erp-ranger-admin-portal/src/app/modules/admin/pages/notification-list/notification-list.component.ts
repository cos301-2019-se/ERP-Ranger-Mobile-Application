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
  displayedColumnsReceivers: string[] = ['park', 'user', 'type', 'edit'];
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

  deleteReportType(id: string) {
    let type: any;
    for (let i = 0; i < this.reportTypes.length; i++) {
      if (this.reportTypes[i].id === id) {
        type = this.reportTypes[i];
        break;
      }
    }
    if (type && confirm('Do you want to delete the "' + type.type + '" report type?')) {
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
    const park = 'iwGnWNuDC3m1hRzNNBT5';
    this.reportReceiverService.getReportReceivers(park).subscribe((results) => {
      this.reportReceivers = [];
      for (let i = 0; i < results.length; i++) {
        this.reportTypeService.readReportType(results[i].payload.doc.data()['type']).subscribe((result) => {
          this.reportReceivers[i] = {
            id: String(results[i].payload.doc.id),
            parkid: String(results[i].payload.doc.data()['park']),
            userid: String(results[i].payload.doc.data()['user']),
            typeid: String(results[i].payload.doc.data()['type']),
            park: String(results[i].payload.doc.data()['park_name']),
            user: String(results[i].payload.doc.data()['user_name']),
            type: String(result.payload.data()['type'])
          };
          this.dataSourceReceivers = new MatTableDataSource(this.reportReceivers);
        });
      }
      this.dataSourceReceivers = new MatTableDataSource(this.reportReceivers);
    });
  }

  deleteReportReceiver(id: string) {
    let type: any;
    for (let i = 0; i < this.reportReceivers.length; i++) {
      if (this.reportReceivers[i].id === id) {
        type = this.reportReceivers[i];
        break;
      }
    }
    if (type && confirm('Do you want to delete the "' + type.type + '" report notification for ' + type.user + '!')) {
      this.reportReceiverService.deleteReportReceiver(id)
        .then(() => {
          alert('Successfully deleted the "' + type.type + '" report notification for ' + type.user + '!');
        })
        .catch(() => {
          alert('Failed to delete the "' + type.type + '" report notification for ' + type.user + '!');
        });
    }
  }

}
