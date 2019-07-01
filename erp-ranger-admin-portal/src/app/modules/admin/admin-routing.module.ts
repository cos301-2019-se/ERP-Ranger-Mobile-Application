import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ShiftNewComponent } from './pages/shift-new/shift-new.component';
import { ShiftListComponent } from './pages/shift-list/shift-list.component';
import { ShiftDetailComponent } from './pages/shift-detail/shift-detail.component';
import { NavComponent } from './components/nav/nav.component';
import { ReportOverviewComponent } from './pages/report-overview/report-overview.component';
import { ReportDetailComponent } from './pages/report-detail/report-detail.component';
import { AddMarkerComponent } from './pages/add-marker/add-marker.component';

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
    path: 'add-marker',
    component: AddMarkerComponent
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
    path: 'dashboard',
    redirectTo: '',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
