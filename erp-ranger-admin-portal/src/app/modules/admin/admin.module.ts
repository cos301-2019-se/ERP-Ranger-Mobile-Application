import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AdminRoutingModule } from './admin-routing.module';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ShiftListComponent } from './pages/shift-list/shift-list.component';
import { ShiftNewComponent } from './pages/shift-new/shift-new.component';
import { ShiftDetailComponent } from './pages/shift-detail/shift-detail.component';

@NgModule({
  declarations: [DashboardComponent, ShiftListComponent, ShiftNewComponent, ShiftDetailComponent],
  imports: [
    CommonModule,
    AdminRoutingModule
  ]
})
export class AdminModule { }
