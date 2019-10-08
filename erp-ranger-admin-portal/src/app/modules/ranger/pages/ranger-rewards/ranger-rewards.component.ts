import { Component, OnInit } from '@angular/core';
import { ProfileService } from "../../services/profile.service";
import { RangerRewardService } from "../../services/ranger-reward.service";
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { AngularFireAuth } from '@angular/fire/auth';

@Component({
  selector: 'app-ranger-rewards',
  templateUrl: './ranger-rewards.component.html',
  styleUrls: ['./ranger-rewards.component.scss']
})
export class RangerRewardsComponent implements OnInit {
  id;
  report;
  rewards;

  constructor(private profile: ProfileService, private route: ActivatedRoute, private users: UserService, private storage: AngularFireStorage, private angularFireAuth: AngularFireAuth, private rewardService: RangerRewardService) { }

  ngOnInit() {
    this.displayDetails();
    this.displayRewards();
  }

  // Retrieve all user data for the user currently logged into their account
  displayDetails() {
    this.id = this.angularFireAuth.auth.currentUser.uid;
    this.profile.getUserDetails(this.id).subscribe(result => {
      this.report = result;
    });
  }

  // Retrieve all rewards currently listed in the database
  displayRewards() {
    this.rewardService.getRewards().subscribe(result => {
      this.rewards = result;
    });
  }
}
