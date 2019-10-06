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
    MatOptionModule,
    MatPaginatorModule
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
    MatOptionModule,
    MatPaginatorModule
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
    MatOptionModule,
    MatPaginatorModule
  ]
})
export class MaterialModule {}
