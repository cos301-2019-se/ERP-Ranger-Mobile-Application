import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { FirebaseStorage } from '@angular/fire';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';


@Component({
  selector: 'app-report-detail',
  templateUrl: './report-detail.component.html',
  styleUrls: ['./report-detail.component.scss']
})
export class ReportDetailComponent implements OnInit {


  zoom: number = 16;

  report;
  user;
  id;
  photo1;
  photo2;
  photo3;

  constructor(private reports: ReportService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage) { }

  ngOnInit() {
    this.displayReports();
  }

  // Function used to retrieve info of each individual marker placed on the map by rangers
  displayReports() {
    this.id = this.route.snapshot.paramMap.get("id");
    this.reports.readReport(this.id).subscribe(result => {
      this.report = result;
      this.users.getUser(this.report['user']).subscribe(async result => {
        this.user = (await result.payload.data()).name;
      });
      //Storage storage2 = firebase.storage();
      //const storageRef = storage2.
      /*storageRef.child('reports/' + this.id + '/1.jpeg').getDownloadURL().then(function(url) {
        console.log(url);
      }).catch(function(error) { console.log(error.code)});*/
      this.storage.ref('reports/' + this.id + '/1.jpeg').getDownloadURL().subscribe( result => {
          this.photo1 = result;
      });
        this.storage.ref('reports/' + this.id + '/2.jpeg').getDownloadURL().subscribe( result => {
          this.photo2 = result;
        });
          this.storage.ref('reports/' + this.id + '/3.jpeg').getDownloadURL().subscribe( result => {
            this.photo3 = result;
          });
    });

  }
  
}
