import {
  Component,
  OnInit
} from '@angular/core';
import {
  RewardService
} from '../../services/reward.service';



@Component({
  selector: 'app-reward-list',
  templateUrl: './reward-list.component.html',
  styleUrls: ['./reward-list.component.scss']
})
export class RewardListComponent implements OnInit {
  rewardArr: Reward[] = [];
  refresher;
  rewardToDel;
  displayedColumns: string[] = ['id', 'name', 'cost', 'url', 'edit', 'delete'];
  constructor(private rewardService: RewardService) {}

  ngOnInit() {
      this.startRefresh();
      this.getRewards();
  }

  //Function find reward in the array
  findRewardWithID(id): string {
      var name = "";
      for (var i = 0; i < this.rewardArr.length; i++) {
          if (this.rewardArr[i].id == id) {
              return this.rewardArr[i].name;
          }
      }


      return name;
  }

  //Refreshes array
  startRefresh() {
      var self = this;
      this.refresher = setInterval(function() {
          self.rewardArr = self.rewardArr;
      }, 1000)

  }

  //stops refreshing
  stopRefresh() {
      this.refresher = clearInterval();
  }

  //confirm overlay when deleting reward
  deleteConfirm(user) {
      this.rewardToDel = user;

      document.getElementById("overlay-confirm-delete").style.visibility = "visible";
      document.getElementById("delete-user").innerHTML = this.findRewardWithID(this.rewardToDel);


  }

  //hides the confirm overlay(Gets rid of delete confirmation)
  hideOverlay() {
      document.getElementById("overlay-confirm-delete").style.visibility = "hidden";

  }

  //if sure to delete, calls deleteReward
  confirmedDelete() {
      var deleted = this.rewardService.deleteReward(this.rewardToDel);
      this.deletedByID(this.rewardToDel);
      this.hideOverlay();
      this.rewardArr = this.rewardArr;

  }

  //deletes the reward from the array
  deletedByID(id) {
      for (var i = 0; i < this.rewardArr.length; i++) {
          if (id == this.rewardArr[i].id) {
              this.rewardArr.splice(i, 1);


          }
      }
  }



  //fetches rewards and populates the table
  getRewards() {
      let observer = this.rewardService.getRewards().ref
          .onSnapshot(querySnapshot => {
              querySnapshot.docChanges().forEach(change => {
                  this.stopRefresh();
                  if (change.type === "removed") {
                  }
                  this.rewardArr = [...this.rewardArr, {
                      id: change.doc.id,
                      name: change.doc.data().name,
                      cost: change.doc.data().cost,
                      url: change.doc.data().url
                  }];
                  this.startRefresh();
              })
          });
  }

}

interface Reward {
  id: string,
      name: string,
      cost: Number,
      url: string,
      edit ? ,
      delete ?

}