import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { FirebaseStorage } from '@angular/fire';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';
import { LightboxConfig, Lightbox } from 'ngx-lightbox';


@Component({
  selector: 'app-report-detail',
  templateUrl: './report-detail.component.new.html',
  styleUrls: ['./report-detail.component.new.scss']
})
export class ReportDetailComponent implements OnInit {
  private _album: Array<any> = [];

  zoom: number = 16;

  report;
  user;
  id;
  photo1;
  photo2;
  photo3;

  constructor(private reports: ReportService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage, private _lightbox: Lightbox, private _lightboxConfig: LightboxConfig) {
      _lightboxConfig.fadeDuration = 1;
   }

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
      this._album = [];
      this.storage.ref('reports/' + this.id + '/1.jpeg').getDownloadURL().subscribe( result => {
          this.photo1 = result;
          const album = {
            src: this.photo1
          };
          this._album.push(album);
      });
        this.storage.ref('reports/' + this.id + '/2.jpeg').getDownloadURL().subscribe( result => {
          this.photo2 = result;
          const album = {
            src: this.photo2
          };
          this._album.push(album);
        });
          this.storage.ref('reports/' + this.id + '/3.jpeg').getDownloadURL().subscribe( result => {
            this.photo3 = result;
          const album = {
            src: this.photo3
          };
          this._album.push(album);
          });
    });

  }

  open(index: number): void {
    // open lightbox
    this._lightbox.open(this._album, index, { wrapAround: true, fitImageInViewPort : true });
  }

  close(): void {
    // close lightbox programmatically
    this._lightbox.close();
  }

  closeReport() {
    // Add check to see if report is still open
    if (confirm('Are you sure you want to close this report?')) {
      this.reports.closeReport(this.id);
    }
  }

  comingSoon() {
    alert('This feature is coming soon.');
  }

}
