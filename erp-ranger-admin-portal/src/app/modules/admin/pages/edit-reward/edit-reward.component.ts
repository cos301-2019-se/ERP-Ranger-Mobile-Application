import { Component, OnInit, ViewChild } from '@angular/core';
import { RewardService } from '../../services/reward.service';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { FormGroupExtension, RxFormBuilder } from '@rxweb/reactive-form-validators';
import { formDirectiveProvider } from '@angular/forms/src/directives/ng_form';
import { fromRef } from '@angular/fire/firestore';
import { ActivatedRoute } from "@angular/router";

@Component({
  selector: 'app-edit-reward',
  templateUrl: './edit-reward.component.html',
  styleUrls: ['./edit-reward.component.scss']
})
export class EditRewardComponent implements OnInit {

  editForm: FormGroup;
  @ViewChild('formDir') formRef;
  id;
  name;
  cost;
  url;

  constructor(private route: ActivatedRoute, private rewardService : RewardService) { }


  //The formgroup is set with all different formcontrol types and validator requirements
  ngOnInit() {
    this.editForm = new FormGroup({
      'cost': new FormControl('', [
        Validators.required,
        Validators.pattern('^[0-9]*'),
        Validators.minLength(1),
        Validators.maxLength(20)
      ]),
      'name': new FormControl('', [
        Validators.required,
      ]),
      'url': new FormControl('', [
        Validators.required,
      ]),
      'imgurl': new FormControl('', [
      ]),
    });
    this.displayReward();
  }


  //resets the form with the values from database
  resetForm(){
    this.editForm.controls.name.setValue(this.name);
    this.editForm.controls.cost.setValue(this.cost);
    this.editForm.controls.url.setValue(this.url);
    
    document.getElementById("edited").innerHTML = "";
  }

  //sets the form fields with the current values from the database
  displayReward(){
    this.id = this.route.snapshot.paramMap.get("id");
    let doc = this.rewardService.getReward(this.id).subscribe(result =>{
      console.log("Result is: " + result)
      this.name = result.payload.data().name;
      this.url = result.payload.data().url;
      this.cost = result.payload.data().cost;
      this.editForm.controls.cost.setValue(this.cost);
      this.editForm.controls.name.setValue(this.name);
      try{
      document.getElementById("titlename").innerHTML= " " + this.name;
      }
      catch(err){
        
      }
      this.editForm.controls.url.setValue(this.url);

    });
  }
    
  //When Add is clicked, the changed are added to the database
  add(){
    var name = this.editForm.get('name').value;
    this.rewardService.setReward(this.id,
      this.editForm.get('name').value,
      this.editForm.get('cost').value,
      this.editForm.get('url').value,
      this.editForm.get('imgurl').value,
    );    
    this.editForm.reset();
    this.formRef.resetForm();
    document.getElementById("added-reward"). innerHTML = name  + " was added."
    
  }

}
