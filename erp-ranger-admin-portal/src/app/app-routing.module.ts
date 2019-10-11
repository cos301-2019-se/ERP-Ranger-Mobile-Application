import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { UserLoginComponent } from './pages/user-login/user-login.component';
import { UnauthGuard } from './guards/unauth.guard';
import { AuthGuard } from './guards/auth.guard';
import { RangerGuard } from './guards/ranger.guard';
import { AdminGuard } from './guards/admin.guard';

const routes: Routes = [
  {
    path: '',
    component: UserLoginComponent,
    canActivate: [UnauthGuard]
  },
  {
    path: 'admin',
    loadChildren: './modules/admin/admin.module#AdminModule',
    canActivate: [AuthGuard]
  },
  {
    path: 'ranger',
    loadChildren: './modules/ranger/ranger.module#RangerModule',
    canActivate: [AuthGuard]
  },
  {
    path: 'login',
    redirectTo: '/',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
