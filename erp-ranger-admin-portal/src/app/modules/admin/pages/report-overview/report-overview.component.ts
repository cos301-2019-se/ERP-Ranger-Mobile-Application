import { Component, OnInit } from '@angular/core';
import { MouseEvent } from '@agm/core';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-report-overview',
  templateUrl: './report-overview.component.html',
  styleUrls: ['./report-overview.component.scss']
})
export class ReportOverviewComponent implements OnInit {

  zoom: number = 13;

  lat: number = -25.876910;
  lng: number = 28.273253;

  markers;

  constructor(private reports: ReportService) { }

  ngOnInit() {
    this.setSize();
    this.displayReports();
  }

  displayReports() {
    this.reports.getReports().subscribe(result => {
      this.markers = result;
    });
  }

  setSize(){
    document.getElementById("map-agm").style.height = (document.body.offsetHeight - 96) + "px";
  }

}
