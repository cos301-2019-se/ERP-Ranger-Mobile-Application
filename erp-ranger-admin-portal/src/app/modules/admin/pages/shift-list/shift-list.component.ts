import { Component, ChangeDetectorRef, ViewChild, TemplateRef, OnInit } from '@angular/core';
import { ShiftService} from '../../services/shift.service';
import { shiftInitState } from '@angular/core/src/view';
import { UserService} from '../../../../services/user.service';

import {firestore} from 'firebase/app';
import Timestamp = firestore.Timestamp;

import { CalendarEvent, CalendarEventAction, CalendarEventTimesChangedEvent, CalendarView} from 'angular-calendar';
import { startOfDay, endOfDay, subDays, addDays, endOfMonth, isSameDay, isSameMonth, addHours} from 'date-fns';
import { Subject } from 'rxjs';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { elementStart } from '@angular/core/src/render3';
import { CalendarDayViewEventComponent } from 'angular-calendar/modules/day/calendar-day-view-event.component';


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

  tempE : tempEvent [] = new Array();
  
  terror : tempEvent;
  shiftsAll;
  size = -1;
  temp = 0;
  counter = 0;
  ngOnInit() {
    this.displayShifts();
    
    
   
  
  }

  ngAfterViewInit() {
    
    
    

    

  }
 

  
 
  constructor(private shifts: ShiftService, private users: UserService, private modal: NgbModal, private cdr: ChangeDetectorRef) {
    
  }
  createTempArr(id: number,name: String, startingDate:Date, endDate:Date) : void{
      var found = false;
      for(var x =0;x< this.tempE.length;x++)
      {
        if(this.tempE[x].id == id)
        {
          found = true;
          return;
        }
      }
      if(!found)
      {
        this.tempE.push(new tempEvent(id,name,startingDate,endDate));
        console.log(id);
        this.addEventP(startingDate,endDate,id);
      }
      
    
    
    
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
    this.modalData = { event, action };
    this.modal.open(this.modalContent, { size: 'lg' });
  }

  addEventP( patrolDate: Date, endDate : Date, i): void {
   
    // this.events.push('df');
    // if (this.size < i)
    // {
    //   this.size = i;
    //   this.events= [
    //     ...this.events,
    //     {
    //       title: 'HERE IT IS',
    //       start: startOfDay(patrolDate),
    //       end: endOfDay(endDate),
    //       color: colors.red,
    //       draggable: false,
    //       resizable: {
    //         beforeStart: false,
    //         afterEnd: false
    //       }
        
    //     }
    //   ]
    // }
    
    console.log(patrolDate + " HIHIHIHI " + endDate);
    console.log("NEW DATE FORMAT" + new Date());
    this.events = [
      ...this.events,
      {
        title: 'HERE IT IS',
        start: startOfDay(patrolDate),
        end: endOfDay(endDate),
        color: colors.red,
        draggable: false,
        resizable: {
          beforeStart: false,
          afterEnd: false
        }
      }
    ];
    console.log(this.events);
  }
  test() : void{
    alert("Hi");
  }
  addEvent( ): void {
    
    var hg = new Date();
    
    this.events = [
      ...this.events,
      {
        
        title: 'here it is',
        start: startOfDay(hg),
        end: endOfDay(hg),
        color: colors.red,
        draggable: true,
        resizable: {
          beforeStart: true,
          afterEnd: true
        }
      }
    ];
    console.log(this.events);
  }
  

  deleteEvent(eventToDelete: CalendarEvent) {
    this.events = this.events.filter(event => event !== eventToDelete);
  }

  setView(view: CalendarView) {
    this.view = view;
  }

  closeOpenMonthViewDay() {
    this.activeDayIsOpen = false;
  }
  
  
}

class tempEvent
{
  id;
  name;
  startingDate;
  endDate;
  constructor(id: number,name: String, startingDate:Date, endDate:Date)
  {
    this.id=id;
    this.name = name;
    this.startingDate = startingDate;
    this.endDate = endDate;
  }
}
