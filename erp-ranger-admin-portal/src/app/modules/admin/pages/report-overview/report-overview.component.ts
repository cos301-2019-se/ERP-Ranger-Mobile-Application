import { Component, OnInit } from '@angular/core';
import { MouseEvent } from '@agm/core';
import { ReportService } from '../../services/report.service';
import { Park } from 'src/app/models/Park.model';

@Component({
  selector: 'app-report-overview',
  templateUrl: './report-overview.component.html',
  styleUrls: ['./report-overview.component.scss']
})
export class ReportOverviewComponent implements OnInit {

  // Set initial zoom intensity
  /*zoom: number = 13;*/
  park: Park;

  // Default map load location - currently Rietvlei dam TODO change to be dynamic
  /*lat: number = -25.876910;
  lng: number = 28.273253;*/
  // tslint:disable-next-line: max-line-length
  // kml = 'https://gist.githubusercontent.com/Jtfnel/77b53014741ec9fce2ffc68d210cdf56/raw/cd8d5bbf2476c48512cb6d44694a52289aa52999/rietvlei.kml';
  defaultui;

  markers;

  constructor(private reports: ReportService) { }

  ngOnInit() {
    this.park = {
      id: '80a612fd-1e2f-4511-8a4a-2d9a87ae4ca5',
      created: 1577905200000,
      updated: 1577905200000,
      name: 'Rietvlei',
      fence: {
        geoJson: {
          type: 'Polygon',
          coordinates: [
            [
              [-25.846247, 28.28001],
              [-25.851809, 28.291168],
              [-25.855207, 28.296661],
              [-25.860305, 28.300953],
              [-25.868646, 28.306618],
              [-25.8766775, 28.312626],
              [-25.886099, 28.320179],
              [-25.892739, 28.323784],
              [-25.903086, 28.325157],
              [-25.913277, 28.3244705],
              [-25.914048, 28.307991],
              [-25.92007, 28.307304],
              [-25.931649, 28.304558],
              [-25.934582, 28.302841],
              [-25.936744, 28.299923],
              [-25.936744, 28.296318],
              [-25.931958, 28.273144],
              [-25.92393, 28.278122],
              [-25.92393, 28.28207],
              [-25.91513, 28.281727],
              [-25.915439, 28.276234],
              [-25.902622, 28.273487],
              [-25.903857, 28.266277],
              [-25.867256, 28.262329],
              [-25.858605, 28.269196],
              [-25.8527355, 28.272972],
              [-25.846247, 28.28001]
            ]
          ]
        }
      }
    };
    // this.setSize();
    this.displayReports();
  }

  // Retrieve all reports submitted to the database and add all markers to the map
  displayReports() {
    this.reports.getReports().subscribe(result => {
      this.markers = result;
    });
  }

  // Set size of AGM map
  /*setSize(){
    document.getElementById("map-agm").style.height = (document.body.offsetHeight-32) + "px";
  }*/

}
