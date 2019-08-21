import { NgModule } from '@angular/core';
import { Routes, RouterModule, ActivatedRoute } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ShiftNewComponent } from './pages/shift-new/shift-new.component';
import { ShiftListComponent } from './pages/shift-list/shift-list.component';
import { ShiftDetailComponent } from './pages/shift-detail/shift-detail.component';
import { NavComponent } from './components/nav/nav.component';
import { ReportOverviewComponent } from './pages/report-overview/report-overview.component';
import { ReportDetailComponent } from './pages/report-detail/report-detail.component';
import { ShiftFeedbackComponent } from './pages/shift-feedback/shift-feedback.component';
import { AddUserComponent } from './pages/add-user/add-user.component';
import { AddMarkerComponent } from './pages/add-marker/add-marker.component';
import { UserPositionsComponent } from './pages/user-positions/user-positions.component';
import { UserListComponent } from './pages/user-list/user-list.component'
import { RewardListComponent } from './pages/reward-list/reward-list.component';
import { AddRewardComponent } from './pages/add-reward/add-reward.component';
import { EditUserComponent } from './pages/edit-user/edit-user.component';
import { NotificationListComponent } from './pages/notification-list/notification-list.component';
import { ReportTypeNewComponent } from './pages/report-type-new/report-type-new.component';
import { ReportTypeUpdateComponent } from './pages/report-type-update/report-type-update.component';
import { ReportReceiverNewComponent } from './pages/report-receiver-new/report-receiver-new.component';


const routes: Routes = [
  {
    path: '',
    component: NavComponent,
    outlet: 'nav'
  },
  {
    path: '',
    component: DashboardComponent
  },
  {
    path: 'shift/feedback',
    component: ShiftFeedbackComponent,
  },
  {
    path: 'users',
    component: UserListComponent,
  },
  {
    path: 'user/:id',
    component: EditUserComponent
  },
  {
    path: 'users/add',
    component: AddUserComponent,
  },
  {
    path: 'rewards',
    component: RewardListComponent,
  },
  {
    path: 'rewards/add',
    component: AddRewardComponent,
  },
  {
    path: 'positions',
    component: UserPositionsComponent,
  },
  {
    path: 'markers',
    component: AddMarkerComponent,
  },
  {
    path: 'marker/:id',
    component: DashboardComponent,
  },
  {
    path: 'shift/new',
    component: ShiftNewComponent
  },
  {
    path: 'shift/:id',
    component: ShiftDetailComponent
  },
  {
    path: 'shifts',
    component: ShiftListComponent
  },
  {
    path: 'reports',
    component: ReportOverviewComponent
  },
  {
    path: 'report/:id',
    component: ReportDetailComponent
  },
  {
    path: 'notifications',
    component: NotificationListComponent
  },
  {
    path: 'type/new',
    component: ReportTypeNewComponent
  },
  {
    path: 'type/:id',
    component: ReportTypeUpdateComponent
  },
  {
    path: 'notification/new',
    component: ReportReceiverNewComponent
  },
  {
    path: 'dashboard',
    redirectTo: '',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule {}
