import { Component, OnInit } from '@angular/core';
import { ReportTypeService } from '../../services/report-type.service';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-report-type-new',
  templateUrl: './report-type-new.component.html',
  styleUrls: ['./report-type-new.component.scss']
})
export class ReportTypeNewComponent implements OnInit {

  reportImportanceList = [
    'Low',
    'Medium',
    'High'
  ];
  reportTypeForm: FormGroup;

  constructor(
    private reportTypeService: ReportTypeService,
    private router: Router
  ) { }

  ngOnInit() {
    this.reportTypeForm = new FormGroup({
      'importance': new FormControl('', [
        Validators.required
      ]),
      'type': new FormControl('', [
        Validators.required
      ]),
      'email': new FormControl(true, []),
      'sms': new FormControl(false, []),
      'api': new FormControl(false, []),
      'web': new FormControl(false, []),
    });
  }

  create() {
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
    this.reportTypeService.addReportType(data)
      .then((result) => {
        alert('Successfully created a new report type!');
        this.router.navigate(['/admin/notifications']);
      })
      .catch((error) => {
        alert('Failed to create a new report type!');
        console.error(error);
      });
  }

}
