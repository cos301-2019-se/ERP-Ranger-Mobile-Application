import { Component, OnInit } from '@angular/core';
import { RewardService } from '../../services/reward.service';



@Component({
  selector: 'app-reward-list',
  templateUrl: './reward-list.component.html',
  styleUrls: ['./reward-list.component.scss']
})
export class RewardListComponent implements OnInit {
  rewardArr: Reward[] =[];
  displayedColumns: string[] = ['id','name','cost','url'];
  constructor(private rewardService : RewardService) { }

  ngOnInit() {
    this.getUsers();
  }

  getUsers(){
    let observer = this.rewardService.getRewards().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        this.rewardArr =[...this.rewardArr,{
          id: change.doc.id,
          name:change.doc.data().name,
          cost:change.doc.data().cost,
          url:change.doc.data().url
        }]
      })
    });
  }

}

interface Reward{
  id: string,
  name:string,
  cost: Number,
  url: string

}
