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
import { TimeInterval } from 'rxjs/internal/operators/timeInterval';

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
  selector: 'app-shift-list',
  templateUrl: './shift-list.component.html',
  styleUrls: ['./shift-list.component.scss'],
})
export class ShiftListComponent implements OnInit {  
  shiftsAll;
  size = -1;
  temp = 0;
  counter = 0;
  refreshInt;
  ngOnInit() {
    this.displayShifts();    
    this.refreshInt = setInterval(function(){this.events = this.events},1000);
  }

  constructor(private shifts: ShiftService, private modal: NgbModal, private cdr: ChangeDetectorRef) {}

  
  
 

  displayShifts() {
    var i = 0;
    let observer = this.shifts.getShifts().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        //console.log(change.doc.data());
        var name :string;        
        var id = change.doc.id;      
        var t = new Date(1970,0,1);
        t.setSeconds(change.doc.data().end.seconds.toString());
        t.setHours(t.getHours() + 2);
        var t2 = new Date(1970,0,1);
        t2.setSeconds(change.doc.data().start.seconds.toString());
        t2.setHours(t2.getHours() + 2);
        let docRef = this.shifts.getUserName(change.doc.data().user);        
        let getUser = docRef.get()
        .then(doc => {
          if(!doc.exists){
            console.log("User not found ");
            
          } else{
            name = doc.data().name ;
            let parkRef = this.shifts.getParkName(change.doc.data().park);
            let getPark = parkRef.get()
            .then(doc => {
              if(!doc.exists){
                console.log("Park not found ");                
              }
              else{
                var park= doc.data().name ;                
                this.addEventP(t2,t,id, name,park);
                
              }
            })  
            .catch(err => {
              console.log("Error getting document");         
            })          
          }
        })
        .catch(err => {
          console.log("Error getting document");         
        });
        i++;
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

  handleEvent(action: string, event: CalendarEvent): void {
    //Do something here when clicking an event    
    this.modalData = { event, action };
    this.modal.open(this.modalContent, { size: 'lg' });
  }

  addEventP( patrolDate: Date, endDate : Date, id, name : string,park : string): void {
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
