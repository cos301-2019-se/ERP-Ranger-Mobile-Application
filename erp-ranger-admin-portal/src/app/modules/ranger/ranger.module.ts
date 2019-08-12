import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RangerRoutingModule } from './ranger-routing.module';
import { ProfileComponent } from './pages/profile/profile.component';
import { NavComponent } from './components/nav/nav.component';
import { MatTableModule } from '@angular/material';
import { MaterialModule } from 'src/app/material.module';

@NgModule({
  declarations: [ProfileComponent, NavComponent],
  imports: [
    CommonModule,
    RangerRoutingModule,
    MatTableModule,
    MaterialModule
  ]
})
export class RangerModule { }
