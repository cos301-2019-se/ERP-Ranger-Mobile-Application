import { Component, OnInit } from '@angular/core';
import { ProfileService } from "../../services/profile.service";
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { AngularFireAuth } from '@angular/fire/auth';

@Component({
  selector: 'app-ranger-leaderboard',
  templateUrl: './ranger-leaderboard.component.html',
  styleUrls: ['./ranger-leaderboard.component.scss']
})
export class RangerLeaderboardComponent implements OnInit {
  report;

  constructor(private profile: ProfileService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage, private angularFireAuth: AngularFireAuth) { }

  ngOnInit() {
    this.displayDetails();
  }

  displayDetails() {
    this.users.getUserLeaderboardData().subscribe(result => {
      this.report = result;
    });
  }
}
