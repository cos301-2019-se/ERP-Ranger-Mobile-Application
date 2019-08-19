import { Component, OnInit } from '@angular/core';
import { Validators, FormGroup, FormControl } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { ReportTypeService } from '../../services/report-type.service';

@Component({
  selector: 'app-report-type-update',
  templateUrl: './report-type-update.component.html',
  styleUrls: ['./report-type-update.component.scss']
})
export class ReportTypeUpdateComponent implements OnInit {

  id;
  reportImportanceList = [
    'Low',
    'Medium',
    'High'
  ];
  loaded = false;
  reportTypeForm: FormGroup;

  constructor(
    private reportTypeService: ReportTypeService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.id = this.route.snapshot.paramMap.get('id');
  }

  ngOnInit() {
    this.reportTypeService.readReportType(this.id).subscribe((result) => {
      this.reportTypeForm = new FormGroup({
        'importance': new FormControl(
          result.payload.data()['importance'],
          [
            Validators.required
          ]
        ),
        'type': new FormControl(
          result.payload.data()['type'],
          [
            Validators.required
          ]
        ),
        'email': new FormControl(
          result.payload.data()['methods']['email'],
          []
        ),
        'sms': new FormControl(
          result.payload.data()['methods']['sms'],
          []
        ),
        'api': new FormControl(
          result.payload.data()['methods']['api'],
          []
        ),
        'web': new FormControl(
          result.payload.data()['methods']['web'],
          []
        ),
      });
      this.loaded = true;
    });
  }

  update() {
    const data = {
      type: this.reportTypeForm.get('type').value,
      importance: this.reportTypeForm.get('importance').value,
      methods: {
        sms: this.reportTypeForm.get('sms').value,
        email: this.reportTypeForm.get('email').value,
        api: this.reportTypeForm.get('api').value,
        web: this.reportTypeForm.get('web').value
      }
    };
    this.reportTypeService.updateReportType(this.id, data)
      .then((result) => {
        alert('Successfully updated a report type!');
        this.router.navigate(['/admin/notifications']);
      })
      .catch((error) => {
        alert('Failed to update a report type!');
        console.error(error);
      });
  }

}
