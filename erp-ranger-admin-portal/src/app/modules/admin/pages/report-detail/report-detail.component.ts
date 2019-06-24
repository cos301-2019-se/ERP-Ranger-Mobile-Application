import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";

@Component({
  selector: 'app-report-detail',
  templateUrl: './report-detail.component.html',
  styleUrls: ['./report-detail.component.scss']
})
export class ReportDetailComponent implements OnInit {

  zoom: number = 13;
  
  lat: number = -25.876910;
  lng: number = 28.273253;

  report;

  constructor(private reports: ReportService, private route: ActivatedRoute) { }

  ngOnInit() {
    this.displayReports();
  }

  displayReports() {
    this.reports.readReport(this.route.snapshot.paramMap.get("id")).subscribe(result => {
      this.report = result;
    });
  }

  getUser(id: string) {
    return "Test user";
  }
}
