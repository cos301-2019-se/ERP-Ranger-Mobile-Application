import { Component, OnInit } from '@angular/core';
import { ShiftService} from '../../services/shift.service';
import { shiftInitState } from '@angular/core/src/view';
import { UserService} from '../../../../services/user.service';

import {firestore} from 'firebase/app';
import Timestamp = firestore.Timestamp;


@Component({
  selector: 'app-shift-list',
  templateUrl: './shift-list.component.html',
  styleUrls: ['./shift-list.component.scss']
})
export class ShiftListComponent implements OnInit {

  constructor(private shifts: ShiftService, private users: UserService) {
    
   }
   shiftsAll;
   temp = 0;
   counter = 0;
  ngOnInit() {
    this.displayShifts();
    
   
  
  }


  
 
 
  getUser(username: String)
  {
    return "Test Ranger";
    this.users.
    getUser(username)
    .subscribe(result => {
      
      return result.payload.data().name;
      
    });
    
    
  }

  displayShifts() {
    this.shifts.
    getShifts().
    subscribe(result => {
      this.shiftsAll = result;
      
    });
  }
  
  
}
