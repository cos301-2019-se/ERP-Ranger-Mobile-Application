import { Component, OnInit, ViewChild } from '@angular/core';
import { RewardService } from '../../services/reward.service';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { FormGroupExtension, RxFormBuilder } from '@rxweb/reactive-form-validators';
import { formDirectiveProvider } from '@angular/forms/src/directives/ng_form';
import { fromRef } from '@angular/fire/firestore';


@Component({
  selector: 'app-add-reward',
  templateUrl: './add-reward.component.html',
  styleUrls: ['./add-reward.component.scss']
})
export class AddRewardComponent implements OnInit {
  
  addForm: FormGroup;
  @ViewChild('formDir') formRef;

  constructor(private rewardService : RewardService) { }
  

  //The formgroup is set with all different formcontrol types and validator requirements
  ngOnInit() {
    this.addForm = new FormGroup({
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
    
  }
  //When the add button is clicked, this adds a reward to the database
  add(){
    var name = this.addForm.get('name').value;
    this.rewardService.addReward(
      this.addForm.get('name').value,
      this.addForm.get('cost').value,
      this.addForm.get('url').value,
      this.addForm.get('imgurl').value,
    );    
    this.addForm.reset();
    this.formRef.resetForm();
    document.getElementById("added-reward"). innerHTML = name  + " was added."
    
  }

}
