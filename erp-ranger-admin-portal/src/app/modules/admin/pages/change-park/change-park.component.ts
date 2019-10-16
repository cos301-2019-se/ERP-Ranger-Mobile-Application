import { Component, OnInit } from '@angular/core';
import { ParkService } from 'src/app/services/park.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-change-park',
  templateUrl: './change-park.component.html',
  styleUrls: ['./change-park.component.scss']
})
export class ChangeParkComponent implements OnInit {

  parks;
  parkForm: FormGroup;

  constructor(
    private parkService: ParkService,
    private router: Router
  ) { }

  ngOnInit() { 
    this.displayParks();
  }

  displayParks() {
    this.parkService.getParks().subscribe(response => {
      this.parks = response;
      this.parkForm = new FormGroup({
        'park': new FormControl('', [
          Validators.required
        ])
      });
    });
  }

  changePark() {
    this.parkService.setParkLocal(this.parkForm.get('park').value.payload.doc.data());
    location.href = '/admin';
  }

}
