import { Component, OnInit, ViewChild, ChangeDetectionStrategy } from '@angular/core';
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { FirebaseStorage } from '@angular/fire';
import * as firebase from 'firebase';
import { FormGroupExtension, RxFormBuilder } from '@rxweb/reactive-form-validators';
import { formDirectiveProvider } from '@angular/forms/src/directives/ng_form';
import { fromRef } from '@angular/fire/firestore';

import { AngularFireAuth } from '@angular/fire/auth';

@Component({
  selector: 'app-edit-ranger',
  templateUrl: './edit-ranger.component.html',
  styleUrls: ['./edit-ranger.component.scss']
})
export class EditRangerComponent implements OnInit {
  editable;
  id;
  profilePic;
  editForm: FormGroup;
  name;
  email;
  number;
  role;
  active;
  points;
  remaining;
  imgFile = null;
  @ViewChild('formDir') formRef;

  constructor(private route: ActivatedRoute, private users : UserService, private storage: AngularFireStorage, private angularFireAuth: AngularFireAuth) { }

  // Construct an edit form to input new, updated data for the current user logged in
  ngOnInit() {
    this.editForm = new FormGroup({
      'email': new FormControl('', [
        Validators.required,
        Validators.email
      ]),      
      'name': new FormControl('', [
        Validators.required,
      ]),
      'number': new FormControl('', [
        Validators.required,
      ]),
      'active': new FormControl('', [
        Validators.required,
        Validators.pattern('^(false)|(true)'),
        Validators.maxLength(5)
      ]),
      'role': new FormControl('', [
        Validators.required,
      ]),
      'points': new FormControl('', [
        Validators.required,
        Validators.pattern('^[0-9]*'),
        
      ]),
      'remaining': new FormControl('', [
        Validators.required,
        Validators.pattern('^[0-9]*'),
        
      ]),
    });
    this.displayUser();
  }

  // Get all stored data of user currently logged in
  displayUser(){
    this.id = this.angularFireAuth.auth.currentUser.uid;
    let doc = this.users.getUser(this.id).subscribe(result =>{
      this.email = result.payload.data().email;
      this.name = result.payload.data().name;
      this.number = result.payload.data().number;
      this.active = result.payload.data().active;
      this.role = result.payload.data().role;
      this.points = result.payload.data().points;
      this.remaining = result.payload.data().remaining;
      this.editForm.controls.email.setValue(this.email);
      this.editForm.controls.name.setValue(this.name);
      try{
      document.getElementById("titlename").innerHTML= this.name;
      }
      catch(err){
        
      }
      this.editForm.controls.number.setValue(this.number);
      this.editForm.controls.active.setValue(this.active);
      this.editForm.controls.role.setValue(this.role);
      this.editForm.controls.points.setValue(this.points);
      this.editForm.controls.remaining.setValue(this.remaining);

      this.storage.ref('users/' + this.id + '/'+  this.id).getDownloadURL().subscribe( result => {
        this.profilePic = result;
        var picField = <HTMLImageElement>document.getElementById("picture");        
        picField.src = this.profilePic;
    },(err)=> {
      this.profilePic = "https://firebasestorage.googleapis.com/v0/b/erp-ranger-app.appspot.com/o/users%2Fdefault%2Fdefault.png?alt=media&token=fa61e670-6070-49b8-ac82-4dbb9161b39f";
      var picField = <HTMLImageElement>document.getElementById("picture");        
      picField.src = this.profilePic});
    })    
    
    
    
    
  }

  // Load profile picture of user currently loggend in
  showImg(){
    var picField = <HTMLImageElement>document.getElementById("picture");
    picField.style.display = "visible";
  }
  onFileSelected(event){
    this.imgFile = event.target.files[0];
    
    var picField = <HTMLImageElement>document.getElementById("picture");
        
        picField.src = window.URL.createObjectURL(this.imgFile);
  }
  updateUser() {
    if(this.detectChanges() == true) {
      this.users.setUser(this.id, this.email, this.name, this.number, this.active,this.role);
    } else {

    }
    if(this.imgFile != null) {
      this.uploadImage();
    }

  }
  

  uploadImage() {   
      var ref = this.storage.ref("users/" + this.id + "/" + this.id);
      ref.put(this.imgFile);
  }

  //checks to see if the form was changed
  detectChanges():boolean{
    let change = false;
    var activeBool = false;
    if((<HTMLInputElement>document.getElementById("active")).value == "true"){
      activeBool = true
    } ;
    
    
    if((this.email == (<HTMLInputElement>document.getElementById("email")).value) && (this.name == (<HTMLInputElement>document.getElementById("name")).value) 
    &&(this.number == (<HTMLInputElement>document.getElementById("number")).value) && (this.active == activeBool)
    &&(this.role == (<HTMLInputElement>document.getElementById("role")).value)&&(this.points == (<HTMLInputElement>document.getElementById("points")).value)
    &&(this.remaining == (<HTMLInputElement>document.getElementById("remaining")).value)){
      change = false;
    }
    else{
      change = true;
      this.email = (<HTMLInputElement>document.getElementById("email")).value;
      this.name = (<HTMLInputElement>document.getElementById("name")).value;
      this.number = (<HTMLInputElement>document.getElementById("number")).value;
      this.role = (<HTMLInputElement>document.getElementById("role")).value;
      this.active = activeBool;
      this.points = (<HTMLInputElement>document.getElementById("points")).value;
      this.remaining = (<HTMLInputElement>document.getElementById("remaining")).value;
      
    }
    

    return change;
  }


  
}
