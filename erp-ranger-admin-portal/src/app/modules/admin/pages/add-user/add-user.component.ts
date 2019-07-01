import { Component, OnInit } from '@angular/core';
import { CreateUserService } from '../../services/create-user.service';
import { FormGroup, Validators, FormControl } from '@angular/forms';

@Component({
  selector: 'app-add-user',
  templateUrl: './add-user.component.html',
  styleUrls: ['./add-user.component.scss']
})
export class AddUserComponent implements OnInit {

  regForm: FormGroup;

  constructor(private auth: CreateUserService) { }

  ngOnInit() {
    this.regForm = new FormGroup({
      'email': new FormControl('', [
        Validators.required,
        Validators.email
      ]),
      'password': new FormControl('', [
        Validators.required,
        Validators.pattern('^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$'),
        Validators.minLength(8),
        Validators.maxLength(20)
      ]),
      'name': new FormControl('', [
        Validators.required,
      ]),
      'number': new FormControl('', [
        Validators.required,
      ]),
    });
  }

  register(){
    this.auth.register(
      this.regForm.get('email').value,
      this.regForm.get('password').value,
      this.regForm.get('name').value,
      this.regForm.get('number').value
    );
  }

}
