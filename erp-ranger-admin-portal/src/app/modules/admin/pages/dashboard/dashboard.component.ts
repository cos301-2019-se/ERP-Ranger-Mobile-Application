import { Component, OnInit, QueryList, ViewChildren } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ReportTypeService } from '../../services/report-type.service';
import { ParkService } from '../../services/park.service';
import { PositionService } from '../../services/position.service';
import { UserService } from 'src/app/services/user.service';
import { MatTableDataSource, MatPaginator } from '@angular/material';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  defaultui = false;
  // tslint:disable-next-line: max-line-length
  kml = 'https://gist.githubusercontent.com/Jtfnel/77b53014741ec9fce2ffc68d210cdf56/raw/cd8d5bbf2476c48512cb6d44694a52289aa52999/rietvlei.kml';
  public mapStyles = [{
    featureType: 'poi',
    elementType: 'labels',
    stylers: [{
      visibility: 'off'
    }]
  }];
  park;
  zoom = 11;
  mapReportList = [];
  mapRangerList = [];
  reportTypes = [];
  reportList = [];
  rangerList = [];
  userList = [];
  w = 30;
  h = 30;
  dataSourceUsers = new MatTableDataSource(this.userList);
  displayedColumnsRangers: string[] = ['name', 'number', 'email'];
  dataSourceReports = new MatTableDataSource(this.reportList);
  displayedColumnsReports: string[] = ['importance', 'type', 'view'];

  iconRanger = {
    url: 'https://fonts.gstatic.com/s/i/materialicons/my_location/v1/24px.svg',
    scaledSize: {
      width: this.w,
      height: this.h
    }
  };

  reportIcons = {
    high: {
      url: 'https://fonts.gstatic.com/s/i/materialicons/new_releases/v1/24px.svg',
      scaledSize: {
        width: this.w,
        height: this.h
      }
    },
    medium: {
      url: 'https://fonts.gstatic.com/s/i/materialicons/report/v1/24px.svg',
      scaledSize: {
        width: this.w,
        height: this.h
      }
    },
    low: {
      url: 'https://fonts.gstatic.com/s/i/materialicons/warning/v1/24px.svg',
      scaledSize: {
        width: this.w,
        height: this.h
      }
    }
  };
  riet;

  @ViewChildren(MatPaginator) paginator = new QueryList<MatPaginator>();

  constructor(
    private reportService: ReportService,
    private typeService: ReportTypeService,
    private parkService: ParkService,
    private rangerService: PositionService,
    private userService: UserService
  ) { }

  ngOnInit() {
    this.riet = {
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
    this.getPark();
    this.getReportTypes();
    this.displayPositions();
  }

  getPark() {
    const park = 'iwGnWNuDC3m1hRzNNBT5'; // @TODO: Fix to use settings
    this.parkService.readPark(park).subscribe((result) => {
      this.park = result.payload.data();
    });
  }

  getReportTypes() {
    this.typeService.getReportTypes().subscribe((results) => {
      this.reportTypes = [];
      for (let i = 0; i < results.length; i++) {
        this.reportTypes.push(results[i].payload.doc.data());
      }
      this.displayReports();
    });
  }

  determineReportIcon (type: string) {
    for (let i = 0; i < this.reportTypes.length; i++) {
      if (String(type).toLowerCase() === String(this.reportTypes[i]['type']).toLowerCase()) { // @TODO: Fix when changing to report type id
        return this.reportIcons[String(this.reportTypes[i]['importance']).toLowerCase()];
      }
    }
    return null;
  }

  getReportType(type: string) {
    for (let i = 0; i < this.reportTypes.length; i++) {
      if (String(type).toLowerCase() === String(this.reportTypes[i]['type']).toLowerCase()) { // @TODO: Fix when changing to report type id
        return this.reportTypes[i];
      }
    }
    return null;
  }

  displayReports() {
    this.reportService.getReports().subscribe((results) => {
      this.mapReportList = results;
      this.reportList = [];
      for (let i = 0; i < results.length; i++) {
        this.reportList.push(results[i].payload.doc.data());
        this.reportList[i]['icon'] = this.determineReportIcon(this.reportList[i]['type']);
        this.reportList[i]['id'] = results[i].payload.doc.id;
        this.reportList[i]['info'] = this.getReportType(this.reportList[i]['type']);
      }
      this.dataSourceReports = new MatTableDataSource(this.reportList);
      this.dataSourceReports.paginator = this.paginator.toArray()[0];
    });
  }

  displayPositions() {
    this.rangerService.getPositions().snapshotChanges().subscribe((results) => {
      const temp = [];
      this.rangerList = [];
      for (let i = 0; i < results.length; i++) {
        const data = results[i].payload.doc.data();
        if (
          (
            data['user'] != null
          ) &&
          (
            (!temp[data['user']]) ||
            (temp[data['user']]['time'].toMillis() < data['time'].toMillis())
          )
        ) {
          temp[data['user']] = data;
        }
      }
      for (const element in temp) {
        if (temp.hasOwnProperty(element)) {
          const data = temp[element];
          data['id'] = element;
          this.rangerList.push(data);
        }
      }
      this.getUsers();
    });
  }

  getUsers() {
    this.userList = [];
    for (let i = 0; i < this.rangerList.length; i++) {
      this.userService.getUser(this.rangerList[i]['id']).subscribe((result) => {
        const data = [];
        data['id'] = String(result.payload.id);
        data['name'] = String(result.payload.data()['name']);
        data['number'] = String(result.payload.data()['number']);
        data['email'] = String(result.payload.data()['email']);
        this.userList.push(data);
        for (let j = 0; j < this.rangerList.length; j++) {
          if (this.rangerList[j]['user'] === data['id']) {
            this.rangerList[j]['ranger'] = data;
          }
        }
        this.dataSourceUsers = new MatTableDataSource(this.userList);
        this.dataSourceUsers.paginator = this.paginator.toArray()[1];
      });
    }
  }

}
