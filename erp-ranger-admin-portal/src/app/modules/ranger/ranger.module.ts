import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RangerRoutingModule } from './ranger-routing.module';
import { ProfileComponent } from './pages/profile/profile.component';
import { NavComponent } from './components/nav/nav.component';
import { MatTableModule } from '@angular/material';
import { MaterialModule } from 'src/app/material.module';
import { EditRangerComponent } from './pages/edit-ranger/edit-ranger.component';
import {FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgbModalModule } from '@ng-bootstrap/ng-bootstrap';
import { RxReactiveFormsModule } from '@rxweb/reactive-form-validators';

@NgModule({
  declarations: [ProfileComponent, NavComponent, EditRangerComponent],
  imports: [
    CommonModule,
    RangerRoutingModule,
    MatTableModule,
    MaterialModule,
    FormsModule,
    NgbModalModule,
    ReactiveFormsModule,
    RxReactiveFormsModule
  ]
})
export class RangerModule { }
