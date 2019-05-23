import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ShiftNewComponent } from './pages/shift-new/shift-new.component';
import { ShiftListComponent } from './pages/shift-list/shift-list.component';
import { ShiftDetailComponent } from './pages/shift-detail/shift-detail.component';
import { ReportOverviewComponent } from './pages/report-overview/report-overview.component';

const routes: Routes = [
  {
    path: 'dashboard',
    component: DashboardComponent
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
    path: '',
    redirectTo: 'dashboard',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
