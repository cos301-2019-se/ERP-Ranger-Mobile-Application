import { Component, OnInit, ViewChild, ChangeDetectionStrategy } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { ActivatedRoute } from "@angular/router";
import { UserService } from 'src/app/services/user.service';
import { FirebaseStorage } from '@angular/fire';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';
import { CreateUserService } from '../../services/create-user.service';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { FormGroupExtension, RxFormBuilder } from '@rxweb/reactive-form-validators';
import { formDirectiveProvider } from '@angular/forms/src/directives/ng_form';
import { fromRef } from '@angular/fire/firestore';



@Component({
  selector: 'app-edit-user',
  templateUrl: './edit-user.component.html',
  styleUrls: ['./edit-user.component.scss']
})
export class EditUserComponent implements OnInit {
  id;
  editable;
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


  constructor(private route: ActivatedRoute, private users : UserService, private storage: AngularFireStorage) { }


  
  //The formgroup is set with all different formcontrol types and validator requirements
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

  //resets the form with values from the database
  resetForm(){
      this.editForm.controls.email.setValue(this.email);
      this.editForm.controls.name.setValue(this.name);
      this.editForm.controls.number.setValue(this.number);
      this.editForm.controls.active.setValue(this.active);
      this.editForm.controls.role.setValue(this.role);
      this.editForm.controls.points.setValue(this.points);
      this.editForm.controls.points.setValue(this.remaining);
      document.getElementById("edited").innerHTML = "";
  }

  //sets the form fields with the current values from the database
  displayUser(){
    this.id = this.route.snapshot.paramMap.get("id");
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
      this.profilePic = "https://firebasestorage.googleapis.com/v0/b/erp-ranger-app.appspot.com/o/users%2Fdefault%2Fdefault.png?alt=media&token=93405721-9f75-46bb-9214-e9117e9d9cd3";
      var picField = <HTMLImageElement>document.getElementById("picture");        
      picField.src = this.profilePic});
    })    
  }

  //Sets the image
  showImg(){
    var picField = <HTMLImageElement>document.getElementById("picture");
    picField.style.display = "visible";
  }

  //updates the image when a file is selected
  onFileSelected(event){
    this.imgFile = event.target.files[0];
    
    var picField = <HTMLImageElement>document.getElementById("picture");
        
        picField.src = window.URL.createObjectURL(this.imgFile);
  }

  //When the form is submitted, calls this to call the user service to update the user
  updateUser(){
    var bool = false;
    if(this.detectChanges() == true){
      this.users.setUser(this.id, this.email, this.name, this.number, this.active,this.role,this.points,this.remaining);
      bool = true;
    }else{

    }
    if(this.imgFile != null){
      this.uploadImage();
      bool = true;
      
    }
    if(bool){
      document.getElementById("edited").innerHTML = this.name + " was edited."
    }

  }
  
  //uploads the image
  uploadImage(){
      
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
