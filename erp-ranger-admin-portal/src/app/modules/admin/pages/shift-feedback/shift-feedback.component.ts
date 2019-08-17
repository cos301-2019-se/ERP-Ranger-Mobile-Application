import { Component, ChangeDetectorRef, ViewChild, TemplateRef, OnInit } from '@angular/core';
import { ShiftService} from '../../services/shift.service';
import { shiftInitState } from '@angular/core/src/view';
import { UserService} from '../../../../services/user.service';
import {firestore} from 'firebase/app';
import Timestamp = firestore.Timestamp;
import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { CalendarEvent, CalendarEventAction, CalendarEventTimesChangedEvent, CalendarView} from 'angular-calendar';
import { startOfDay, endOfDay, subDays, addDays, endOfMonth, isSameDay, isSameMonth, addHours} from 'date-fns';
import { Subject } from 'rxjs';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { elementStart } from '@angular/core/src/render3';
import { CalendarDayViewEventComponent } from 'angular-calendar/modules/day/calendar-day-view-event.component';
import { google } from '@agm/core/services/google-maps-types';

const colors: any = {
  red: {
    primary: '#ad2121',
    secondary: '#FAE3E3'
  },
  blue: {
    primary: '#1e90ff',
    secondary: '#D1E8FF'
  },
  yellow: {
    primary: '#e3bc08',
    secondary: '#FDF1BA'
  }
};

@Component({
  selector: 'app-shift-feedback',
  templateUrl: './shift-feedback.component.html',
  styleUrls: ['./shift-feedback.component.scss'],
})
export class ShiftFeedbackComponent implements OnInit {  
  shiftsAll;
  size = -1;
  temp = 0;
  counter = 0;
  refreshInt;
  ngOnInit() {
    this.displayShifts();
    this.refreshInt = setInterval(function(){this.events = this.events;},1000);
  }


  constructor(private shifts: ShiftService, private modal: NgbModal, private cdr: ChangeDetectorRef) {}

  
  
 

  displayShifts() {
    var i = 0;
    let observer = this.shifts.getFeedback().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        var patrolID :string;
        patrolID = change.doc.data().patrol;
        var feedBackInfo = change.doc.data().feedback;
        let docRef = this.shifts.getPatrol(patrolID);        
        let getPatrol = docRef.get()
        .then(doc => {
          if(!doc.exists){
            console.log("Patrol not found ");
            
          } else{
            var endTime = doc.data().end;
            var startTime = doc.data().start;
            var parkID = doc.data().park;
            var shiftID = doc.data().shift;
            var userID = doc.data().user;
            let docRef = this.shifts.getUserName(userID);        
            let getUser = docRef.get()
            .then(userDoc => {
              if(!doc.exists){
                console.log("User not found ");
                
              } else{     
                var userName = userDoc.data().name;
                let docRef = this.shifts.getParkName(parkID);        
                let getPark = docRef.get()
                .then(parkDoc => {
                  if(!parkDoc.exists){
                    console.log("User not found ");
                    
                  } else{     
                    // console.log(change.doc.data());
                    // console.log(doc.data());
                    // console.log(parkDoc.data());
                    
                    var parkName = parkDoc.data().name;
                    var start = startTime.toDate();
                   
                    var end = endTime.toDate();
                    // console.log(start);
                    // console.log(end);
                    
                    // console.log("--------------------");
                    // console.log(start,end,change.doc.id,userName,parkName, feedBackInfo);
                    
                    
                    this.addEventP(start,end,change.doc.id,userName,parkName, feedBackInfo);
                  }
                })
                .catch(err => {
                  console.log("Error getting document");         
                });
              }
            })
            .catch(err => {
              console.log("Error getting document");         
            });

            
          }
        })
        .catch(err => {
          console.log("Error getting document");         
        });
      });
    });

    
  }
  
  @ViewChild('modalContent') modalContent: TemplateRef<any>;

  view: CalendarView = CalendarView.Month;

  CalendarView = CalendarView;

  viewDate: Date = new Date();

  modalData: {
    action: string;
    event: CalendarEvent;
  };

  actions: CalendarEventAction[] = [
    {
      label: '<i class="fa fa-fw fa-pencil">this is on click label</i>',
      onClick: ({ event }: { event: CalendarEvent }): void => {
        this.handleEvent('Edited', event);
      }
    },
    {
      label: '<i class="fa fa-fw fa-times">...Follows previous label</i>',
      onClick: ({ event }: { event: CalendarEvent }): void => {
        this.events = this.events.filter(iEvent => iEvent !== event);
        this.handleEvent('Deleted', event);
      }
    }
  ];

  refresh: Subject<any> = new Subject();
  events: CalendarEvent[] = [
    
  ];
  activeDayIsOpen: boolean = true;
  dayClicked({ date, events }: { date: Date; events: CalendarEvent[] }): void {
    if (isSameMonth(date, this.viewDate)) {
      this.viewDate = date;
      if (
        (isSameDay(this.viewDate, date) && this.activeDayIsOpen === true) ||
        events.length === 0
      ) {
        this.activeDayIsOpen = false;
      } else {
        this.activeDayIsOpen = true;
      }
    }
  }

  eventTimesChanged({
    event,
    newStart,
    newEnd
  }: CalendarEventTimesChangedEvent): void {
    this.events = this.events.map(iEvent => {
      if (iEvent === event) {
        return {
          ...event,
          start: newStart,
          end: newEnd
        };
      }
      return iEvent;
    });
    this.handleEvent('Dropped or resized', event);
  }
  hideOverlay(){
    document.getElementById("overlay-info").style.visibility = "hidden";
  }
  handleEvent(action: string, event: CalendarEvent): void {
    //Do something here when clicking an event   
    let docRef = this.shifts.getFeedbackID(event.id + "");        
    let getFB = docRef.get()
    .then(fDoc => {
      if(!fDoc.exists){
        console.log("User not found ");
        
      } else{     
        document.getElementById("overlay-span").innerHTML = fDoc.data().feedback;
        document.getElementById("overlay-info").style.visibility = "visible";
        
        
      }
    })
    .catch(err => {
      console.log("Error getting document");         
    });
    this.modalData = { event, action };
    this.modal.open(this.modalContent, { size: 'lg' });
  }
  doSomething(){
    this.refreshInt=setInterval(function(){this.event= this.events}, 1000);
  }
  addEventP( patrolDate: Date, endDate : Date, id, name : string,park : string, info: string): void {
    this.events = [
      ...this.events,
      {
        title:    name + " ( " + patrolDate.getHours() +":"+  patrolDate.getMinutes() + "  -  "+ endDate.getHours() +":"+  endDate.getMinutes() + " ) At " + park ,
        start: startOfDay(patrolDate),
        end: endOfDay(endDate),
        id : id,        
        color: colors.blue,
        draggable: false,
        resizable: {
          beforeStart: false,
          afterEnd: false
        }
      }
    ];   
    
  }

  deleteEvent(eventToDelete: CalendarEvent) {
    this.events = this.events.filter(event => event !== eventToDelete);
  }

 
  closeOpenMonthViewDay() {
    this.activeDayIsOpen = false;
  }
  
  
}
