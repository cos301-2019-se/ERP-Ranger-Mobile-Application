import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ProfileComponent } from './pages/profile/profile.component';
import { NavComponent } from './components/nav/nav.component';
import { EditRangerComponent } from './pages/edit-ranger/edit-ranger.component';
import { RangerLeaderboardComponent } from './pages/ranger-leaderboard/ranger-leaderboard.component';
import { RangerRewardsComponent } from './pages/ranger-rewards/ranger-rewards.component';

// Used to create route links between each page
const routes: Routes = [
  {
    path: '',
    component: NavComponent,
    outlet: 'nav'
  },
  {
    path: 'profile',
    component: ProfileComponent,
  },
  {
    path: 'profile/:id',
    component: EditRangerComponent,
  }, 
  {
    path: 'leaderboard',
    component: RangerLeaderboardComponent,
  },
  {
    path: 'rewards',
    component: RangerRewardsComponent
  }

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RangerRoutingModule { }
