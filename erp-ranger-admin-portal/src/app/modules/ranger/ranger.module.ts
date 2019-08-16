import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RangerRoutingModule } from './ranger-routing.module';
import { ProfileComponent } from './pages/profile/profile.component';
import { NavComponent } from './components/nav/nav.component';
import { MatTableModule } from '@angular/material';
import { MaterialModule } from 'src/app/material.module';
import { EditRangerComponent } from './pages/edit-ranger/edit-ranger.component';

@NgModule({
  declarations: [ProfileComponent, NavComponent, EditRangerComponent],
  imports: [
    CommonModule,
    RangerRoutingModule,
    MatTableModule,
    MaterialModule
  ]
})
export class RangerModule { }
