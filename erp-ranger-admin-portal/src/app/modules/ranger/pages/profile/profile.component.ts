import { Component, OnInit } from '@angular/core';
import { ProfileService } from "../../services/profile.service";
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { AngularFireAuth } from '@angular/fire/auth';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  id;
  report;
  profilePic;

  constructor(private profile: ProfileService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage, private angularFireAuth: AngularFireAuth) { }

  ngOnInit() {
    this.displayDetails();
  }


  // Retrieve all user data for the user currently logged into their account
  displayDetails() {
    this.id = this.angularFireAuth.auth.currentUser.uid;
    this.profile.getUserDetails(this.id).subscribe(result => {
      this.report = result;

      this.storage.ref('users/' + this.id + '/'+  this.id).getDownloadURL().subscribe( result => {
        this.profilePic = result;
        var picField = <HTMLImageElement>document.getElementById("picture");        
        picField.src = this.profilePic;
    },(err)=> {
      this.profilePic = "https://firebasestorage.googleapis.com/v0/b/erp-ranger-app.appspot.com/o/users%2Fdefault%2Fdefault.png?alt=media&token=fa61e670-6070-49b8-ac82-4dbb9161b39f";
      var picField = <HTMLImageElement>document.getElementById("picture");        
      picField.src = this.profilePic});
    });
  }

  // Display profile picture of user currently logged in
  showImg(){
    var picField = <HTMLImageElement>document.getElementById("picture");
    picField.style.display = "visible";
  }
}
