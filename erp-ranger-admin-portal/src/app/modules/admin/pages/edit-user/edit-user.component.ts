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
  profilePic;
  editForm: FormGroup;
  name;
  email;
  number;
  role;
  active;
  imgFile = null;
  @ViewChild('formDir') formRef;


  constructor(private route: ActivatedRoute, private users : UserService, private storage: AngularFireStorage) { }

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
    });
    this.displayUser();
  }

  displayUser(){
    this.id = this.route.snapshot.paramMap.get("id");
    let doc = this.users.getUser(this.id).subscribe(result =>{
      this.email = result.payload.data().email;
      this.name = result.payload.data().name;
      this.number = result.payload.data().number;
      this.active = result.payload.data().active;
      this.role = result.payload.data().role;
      this.editForm.controls.email.setValue(this.email);
      this.editForm.controls.name.setValue(this.name);
      document.getElementById("titlename").innerHTML= this.name;
      this.editForm.controls.number.setValue(this.number);
      this.editForm.controls.active.setValue(this.active);
      this.editForm.controls.role.setValue(this.role);

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

  showImg(){
    var picField = <HTMLImageElement>document.getElementById("picture");
    picField.style.display = "visible";
  }
  onFileSelected(event){
    this.imgFile = event.target.files[0];
    
    var picField = <HTMLImageElement>document.getElementById("picture");
        
        picField.src = window.URL.createObjectURL(this.imgFile);
  }
  updateUser(){
    if(this.detectChanges() == true){
      this.users.setUser(this.id, this.email, this.name, this.number, this.active,this.role);
      
    }else{

    }
    if(this.imgFile != null){
      this.uploadImage();
      
    }

  }
  

  uploadImage(){
      
      var ref = this.storage.ref("users/" + this.id + "/" + this.id);
      ref.put(this.imgFile);
      
      
      
      
  
  }

  detectChanges():boolean{
    let change = false;
    var activeBool = false;
    if((<HTMLInputElement>document.getElementById("active")).value == "true"){
      activeBool = true
    } ;
    
    
    if((this.email == (<HTMLInputElement>document.getElementById("email")).value) && (this.name == (<HTMLInputElement>document.getElementById("name")).value) 
    &&(this.number == (<HTMLInputElement>document.getElementById("number")).value) && (this.active == activeBool)
    &&(this.role == (<HTMLInputElement>document.getElementById("role")).value)){
      change = false;
    }
    else{
      change = true;
      this.email = (<HTMLInputElement>document.getElementById("email")).value;
      this.name = (<HTMLInputElement>document.getElementById("name")).value;
      this.number = (<HTMLInputElement>document.getElementById("number")).value;
      this.role = (<HTMLInputElement>document.getElementById("role")).value;
      this.active = activeBool;
      
    }
    

    return change;
  }

}
