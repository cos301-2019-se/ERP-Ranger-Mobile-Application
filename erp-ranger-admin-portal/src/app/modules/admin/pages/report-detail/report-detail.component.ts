import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";

@Component({
  selector: 'app-report-detail',
  templateUrl: './report-detail.component.html',
  styleUrls: ['./report-detail.component.scss']
})
export class ReportDetailComponent implements OnInit {

  report;

  constructor(private reports: ReportService, private route: ActivatedRoute) { }

  ngOnInit() {
    this.displayReports();
  }

  displayReports() {
    this.reports.readReport(this.route.snapshot.paramMap.get("id")).subscribe(result => {
      this.report = result;
      console.log(this.report);
    });
  }

}
