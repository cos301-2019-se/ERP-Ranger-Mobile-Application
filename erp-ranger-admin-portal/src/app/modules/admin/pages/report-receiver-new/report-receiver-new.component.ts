import { Component, OnInit } from '@angular/core';
import { ReportTypeService } from '../../services/report-type.service';
import { ParkService } from '../../services/park.service';
import { UserService } from 'src/app/services/user.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { ReportReceiversService } from '../../services/report-receivers.service';
import { MatOptionSelectionChange } from '@angular/material';
import { map, startWith } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { Router } from '@angular/router';

@Component({
  selector: 'app-report-receiver-new',
  templateUrl: './report-receiver-new.component.html',
  styleUrls: ['./report-receiver-new.component.scss']
})
export class ReportReceiverNewComponent implements OnInit {

  parkList = [];
  adminList = [];
  reportList = [];
  filteredParks: Observable<any[]>;
  filteredUsers: Observable<any[]>;
  filteredTypes: Observable<any[]>;
  reportReceiverForm: FormGroup;
  docIds = {};

  constructor(
    private parkService: ParkService,
    private reportTypeService: ReportTypeService,
    private userService: UserService,
    private receiverService: ReportReceiversService,
    private router: Router
  ) { }

  ngOnInit() {
    this.reportReceiverForm = new FormGroup({
      'user': new FormControl('', [
        Validators.required
      ]),
      'type': new FormControl('', [
        Validators.required
      ]),
      'park': new FormControl('', [
        Validators.required
      ])
    });
    this.getParks();
    this.getAdmins();
    this.getReportTypes();
  }

  getParks() {
    this.parkService.getParks().subscribe((results) => {
      this.parkList = [];
      for (let i = 0; i < results.length; i++) {
        this.parkList[i] = {
          id: results[i].payload.doc.id,
          name: results[i].payload.doc.data()['name']
        };
      }
      this.filteredParks = this.reportReceiverForm.get('park').valueChanges
        .pipe(
          startWith(''),
          map((value) => {
            const filterValue = value.toLowerCase();
            return this.parkList.filter(option => option.name.toLowerCase().includes(filterValue));
          })
        );
    });
  }

  getAdmins() {
    this.userService.getAllUsers(true).subscribe((results) => {
      this.adminList = [];
      for (let i = 0; i < results.length; i++) {
        this.adminList[i] = {
          id: results[i].payload.doc.id,
          name: results[i].payload.doc.data()['name']
        };
      }
      this.filteredUsers = this.reportReceiverForm.get('user').valueChanges
        .pipe(
          startWith(''),
          map((value) => {
            const filterValue = value.toLowerCase();
            return this.adminList.filter(option => option.name.toLowerCase().includes(filterValue));
          })
        );
    });
  }

  getReportTypes() {
    this.reportTypeService.getReportTypes().subscribe((results) => {
      this.reportList = [];
      for (let i = 0; i < results.length; i++) {
        this.reportList[i] = {
          id: results[i].payload.doc.id,
          name: results[i].payload.doc.data()['type']
        };
      }
      this.filteredTypes = this.reportReceiverForm.get('type').valueChanges
        .pipe(
          startWith(''),
          map((value) => {
            const filterValue = value.toLowerCase();
            return this.reportList.filter(option => option.name.toLowerCase().includes(filterValue));
          })
        );
    });
  }

  setDocId(event: MatOptionSelectionChange, key, id) {
    if (event.isUserInput) {
      this.docIds[key] = id;
    }
  }

  create() {
    try {
      const data = {
        user_name: this.reportReceiverForm.get('user').value,
        park_name: this.reportReceiverForm.get('park').value,
        user: this.docIds['user'],
        park: this.docIds['park'],
        type: this.docIds['type']
      };
      this.receiverService.addReportReceiver(data)
        .then((result) => {
          alert('Successfully added a new notification!');
          this.router.navigate(['/admin/notifications']);
        })
        .catch((error) => {
          alert('Failed to add a new notification.');
          console.error(error);
        });
    } catch (error) {
      console.error(error);
    }
  }

}
