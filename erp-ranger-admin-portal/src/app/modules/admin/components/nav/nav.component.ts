import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { ParkService } from 'src/app/services/park.service';

@Component({
  selector: 'app-nav',
  templateUrl: './nav.component.html',
  styleUrls: ['./nav.component.scss']
})
export class NavComponent implements OnInit {
 
  park;

  constructor(private auth: AuthService, private parkService: ParkService) { }

  ngOnInit() {
    this.park = this.parkService.getParkLocal();
    if (!this.park) {
      this.park = {
        name: 'Oops!'
      }
    }
  }

  logout() {
    this.auth.logout();
  }

}
