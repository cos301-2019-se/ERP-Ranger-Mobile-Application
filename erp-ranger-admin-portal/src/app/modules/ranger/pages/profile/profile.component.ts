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

  constructor(private profile: ProfileService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage, private angularFireAuth: AngularFireAuth) { }

  ngOnInit() {
    this.displayDetails();
  }


  // Retrieve all user data for the user currently logged into their account
  displayDetails() {
    this.id = this.angularFireAuth.auth.currentUser.uid;
    this.profile.getUserDetails(this.id).subscribe(result => {
      this.report = result;
    });
  }
}
