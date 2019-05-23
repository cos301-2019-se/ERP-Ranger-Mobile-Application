import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RangerRoutingModule } from './ranger-routing.module';
import { ProfileComponent } from './pages/profile/profile.component';

@NgModule({
  declarations: [ProfileComponent],
  imports: [
    CommonModule,
    RangerRoutingModule
  ]
})
export class RangerModule { }
