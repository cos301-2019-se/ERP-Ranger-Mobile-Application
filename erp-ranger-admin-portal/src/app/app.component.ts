import { Component } from '@angular/core';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  loggedIn: boolean = false;

  constructor(private auth: AuthService) {
    this.auth.user.subscribe(result => {
      if(result != null) {
        this.loggedIn = true;
      } else {
        this.loggedIn = false;
      }
    });
  }

  logout() {
    this.auth.logout();
  }

}
