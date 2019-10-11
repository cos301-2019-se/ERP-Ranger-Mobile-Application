import { Component, OnInit } from '@angular/core';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-user-login',
  templateUrl: './user-login.component.html',
  styleUrls: ['./user-login.component.scss']
})
export class UserLoginComponent implements OnInit {

  loginForm: FormGroup;

  constructor(private auth: AuthService) { }

  ngOnInit() {
    this.loginForm = new FormGroup({
      'email': new FormControl('', [
        Validators.required,
        Validators.email
      ]),
      'password': new FormControl('', [
        Validators.required,
        Validators.pattern('^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$'),
        Validators.minLength(8),
        Validators.maxLength(20)
      ])
    });
  }

  login() {
    this.auth.login(
      this.loginForm.get('email').value,
      this.loginForm.get('password').value
    );
  }

}
