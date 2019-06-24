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

  report;

  constructor(private reports: ReportService, private route: ActivatedRoute) { }

  ngOnInit() {
    this.displayReports();
  }

  // Function used to retrieve info of each individual marker placed on the map by rangers
  displayReports() {
    this.reports.readReport(this.route.snapshot.paramMap.get("id")).subscribe(result => {
      this.report = result;
    });
  }

  getUser(id: string) {
    return "Test user";
  }
}
