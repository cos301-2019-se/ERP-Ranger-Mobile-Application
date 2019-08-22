import { NgModule } from '@angular/core';

import {
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatSnackBarModule,
    MatFormFieldModule,
    MatInputModule,
    MatTabsModule,
    MatDialogModule,
    MatCheckboxModule,
    MatSelectModule,
    MatAutocompleteModule,
    MatOptionModule
} from '@angular/material';

@NgModule({
  imports: [
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatSnackBarModule,
    MatFormFieldModule,
    MatInputModule,
    MatTabsModule,
    MatDialogModule,
    MatCheckboxModule,
    MatSelectModule,
    MatAutocompleteModule,
    MatOptionModule
  ],
  exports: [
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatSnackBarModule,
    MatFormFieldModule,
    MatInputModule,
    MatTabsModule,
    MatDialogModule,
    MatCheckboxModule,
    MatSelectModule,
    MatAutocompleteModule,
    MatOptionModule
  ]
})
export class MaterialModule {}
