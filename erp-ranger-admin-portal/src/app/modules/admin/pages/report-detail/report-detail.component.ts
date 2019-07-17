import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-report-detail',
  templateUrl: './report-detail.component.html',
  styleUrls: ['./report-detail.component.scss']
})
export class ReportDetailComponent implements OnInit {

  
  zoom: number = 13;

  report;
  user;

  constructor(private reports: ReportService, private route: ActivatedRoute, private users: UserService) { }

  ngOnInit() {
    this.displayReports();
  }

  // Function used to retrieve info of each individual marker placed on the map by rangers
  displayReports() {
    this.reports.readReport(this.route.snapshot.paramMap.get("id")).subscribe(result => {
      this.report = result;
      this.users.getUser(this.report['user']).subscribe(result => {
        this.user = result;
      });
    });
  }

}
