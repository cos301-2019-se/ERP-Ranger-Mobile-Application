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
import { AgmCoreModule } from '@agm/core';

import { ReportDetailComponent } from './pages/report-detail/report-detail.component';
import { FormsModule } from '@angular/forms';
          
import { FlatpickrModule } from 'angularx-flatpickr';
import { CalendarModule, DateAdapter } from 'angular-calendar';
import { adapterFactory } from 'angular-calendar/date-adapters/date-fns';
import { NgbModalModule } from '@ng-bootstrap/ng-bootstrap';
import { NgInitDirective } from './pages/shift-list/shift-list.directive';

@NgModule({
  declarations: [DashboardComponent, ShiftListComponent, ShiftNewComponent, ShiftDetailComponent, NavComponent, ReportOverviewComponent, ReportDetailComponent, NgInitDirective],

  imports: [
    CommonModule,
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
