import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  loggedIn: boolean;

  constructor() {
    this.loggedIn = false;
  }

  logout() {
    console.log('logged out!');
  }

}
