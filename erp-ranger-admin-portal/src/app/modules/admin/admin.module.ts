import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AdminRoutingModule } from './admin-routing.module';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ShiftListComponent } from './pages/shift-list/shift-list.component';
import { ShiftNewComponent } from './pages/shift-new/shift-new.component';
import { ShiftDetailComponent } from './pages/shift-detail/shift-detail.component';
import { NavComponent } from './components/nav/nav.component';
import { MaterialModule } from 'src/app/material.module';
import { ReportOverviewComponent } from './pages/report-overview/report-overview.component';
import { ShiftFeedbackComponent } from './pages/shift-feedback/shift-feedback.component';
import { ReportDetailComponent } from './pages/report-detail/report-detail.component';
import { AddMarkerComponent } from './pages/add-marker/add-marker.component';
import { BrowserModule } from '@angular/platform-browser';
import { AddUserComponent } from './pages/add-user/add-user.component';
import {FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RxReactiveFormsModule } from '@rxweb/reactive-form-validators';
import { resolve } from 'dns';
import { FlatpickrModule } from 'angularx-flatpickr';
import { CalendarModule, DateAdapter } from 'angular-calendar';
import { adapterFactory } from 'angular-calendar/date-adapters/date-fns';
import { NgbModalModule } from '@ng-bootstrap/ng-bootstrap';
import { AgmCoreModule } from '@agm/core';
import { UserPositionsComponent } from './pages/user-positions/user-positions.component';
import { UserListComponent } from './pages/user-list/user-list.component';
import { MatTableModule } from '@angular/material';
import { RewardListComponent } from './pages/reward-list/reward-list.component';
import { AddRewardComponent } from './pages/add-reward/add-reward.component';
import { EditUserComponent } from './pages/edit-user/edit-user.component';
import { NotificationListComponent } from './pages/notification-list/notification-list.component';
import { ReportTypeNewComponent } from './pages/report-type-new/report-type-new.component';
import { ReportTypeUpdateComponent } from './pages/report-type-update/report-type-update.component';
import { ReportReceiverNewComponent } from './pages/report-receiver-new/report-receiver-new.component';
import { EditRewardComponent } from './pages/edit-reward/edit-reward.component';

@NgModule({

  declarations: [DashboardComponent, ReportDetailComponent, ShiftFeedbackComponent,
    ShiftListComponent, ShiftNewComponent, ShiftDetailComponent, NavComponent, AddMarkerComponent,
    ReportOverviewComponent, AddUserComponent, UserPositionsComponent, UserListComponent, RewardListComponent,
    AddRewardComponent, EditUserComponent, NotificationListComponent, ReportTypeNewComponent, ReportTypeUpdateComponent,
    ReportReceiverNewComponent, EditRewardComponent
  ],

  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatTableModule,
    RxReactiveFormsModule,
    AdminRoutingModule,
    MaterialModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyArcavcPL0-hdLcbknUGGx9xdX6NR1AJ0o'
      //apiKey: 'AIzaSyAvcDy5ZYc2ukCS6TTtI3RYX5QmuoV8Ffw'
    }),

    FormsModule,
    NgbModalModule,
    FlatpickrModule.forRoot(),
    CalendarModule.forRoot({
      provide: DateAdapter,
      useFactory: adapterFactory
    })
  ],
  exports: [ShiftListComponent]
})
export class AdminModule { }
