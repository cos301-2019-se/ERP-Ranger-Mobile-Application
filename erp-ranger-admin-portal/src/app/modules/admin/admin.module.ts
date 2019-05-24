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

@NgModule({
  declarations: [DashboardComponent, ShiftListComponent, ShiftNewComponent, ShiftDetailComponent, NavComponent, ReportOverviewComponent],
  imports: [
    CommonModule,
    AdminRoutingModule,
    MaterialModule,
    AgmCoreModule.forRoot({
      apiKey: 'AIzaSyArcavcPL0-hdLcbknUGGx9xdX6NR1AJ0o'
      //apiKey: 'AIzaSyAvcDy5ZYc2ukCS6TTtI3RYX5QmuoV8Ffw'
    })
  ]
})
export class AdminModule { }
