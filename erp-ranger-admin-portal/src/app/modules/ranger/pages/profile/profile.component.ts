import { Component, OnInit } from '@angular/core';
import { ProfileService } from "../../services/profile.service";
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { AngularFireStorage } from '@angular/fire/storage';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {

  id;
  report;

  constructor(private profile: ProfileService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage) { }

  ngOnInit() {
    this.displayDetails();
  }

  displayDetails() {
    this.id = this.route.snapshot.paramMap.get("id");
    this.profile.getUserDetails(this.id).subscribe(result => {
      this.report = result;
    });
  }
}
