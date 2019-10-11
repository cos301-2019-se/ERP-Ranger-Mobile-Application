import { Component, ChangeDetectorRef, ViewChild, TemplateRef, OnInit, ViewEncapsulation } from '@angular/core';
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
import { AngularFireStorage } from '@angular/fire/storage';
import { ReportService } from '../../services/report.service';

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
  encapsulation: ViewEncapsulation.None
})
export class ShiftFeedbackComponent implements OnInit {  
  shiftsAll;
  size = -1;
  temp = 0;
  counter = 0;
  refreshInt;
  reports : reportType[] =[];
  ngOnInit() {
    this.displayShifts();
    this.refreshInt = setInterval(function(){this.events = this.events;},1000);
  }


  constructor(private shifts: ShiftService, private report : ReportService, private modal: NgbModal, private cdr: ChangeDetectorRef, private storage: AngularFireStorage) {}

  
  
 
  //Fetches all the details about shift feedback documents and populates the events array which in turn populates the calendar
  displayShifts() {
    var i = 0;
    let observer = this.shifts.getFeedback().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        var patrolID :string;
        patrolID = change.doc.data().patrol;
        var feedBackInfo = change.doc.data().feedback;
        
        if(patrolID == null || patrolID ==""){

        }
        else{
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
                    console.log("Park not found ");
                    
                  } else{     
                    var parkName = parkDoc.data().name;
                    var start = startTime.toDate();                   
                    var end = endTime.toDate();                    
                    this.addEventP(start,end,change.doc.id+ "," + userDoc.data().uid+","+patrolID,userName,parkName, feedBackInfo);
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
        })
      }});
    });
    let obs = this.report.getAllReports().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if(change.doc.data().patrol){
          this.reports.push({ patrol: change.doc.data().patrol,
            type: change.doc.data().type});   
            console.log(change.doc.data().patrol);
        }          
      })
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
    document.getElementById("card-footer").innerHTML="";
    var fid =  event.id.toString().substring(0,event.id.toString().indexOf(","));
    var uid = event.id.toString().substring(event.id.toString().indexOf(",")+1);
    var pid = uid.substring(uid.indexOf(",")+1);
    var uid = uid.substring(0,uid.indexOf(","));
    for(var x =0;x< this.reports.length;x++){
      console.log(pid + "=?" + this.reports[x].patrol);
      if(pid == this.reports[x].patrol){
        document.getElementById("card-footer").innerHTML +="<span class='footer-label'>"+ this.reports[x].type + "</span>";
        
      }
    }
      
    
    console.log(uid);
    let docRef = this.shifts.getFeedbackID(fid + ""); 
    let getFB = docRef.get()
    .then(fDoc => {
      if(!fDoc.exists){
        console.log("Feedback doc not found ");
        
      } else{     
        var id = event.id.toString().substring(event.id.toString().indexOf(","));        
        this.storage.ref('users/' + uid + '/'+  uid).getDownloadURL().subscribe( result => {
          var profilePic = result;
          document.getElementById("prof-pic").style.backgroundImage = "url(" + profilePic+ ")";
        },(err)=> {
          var profilePic = "https://firebasestorage.googleapis.com/v0/b/erp-ranger-app.appspot.com/o/users%2Fdefault%2Fdefault.png?alt=media&token=93405721-9f75-46bb-9214-e9117e9d9cd3";
          document.getElementById("prof-pic").style.backgroundImage = "url(" + profilePic+ ")";
        });
        document.getElementById("overlay-span").innerHTML = fDoc.data().feedback;
        document.getElementById("ranger-subtitle").innerHTML = event.title;
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

  getTimeFormat(time : string) : String{
    if(time.length == 1){
      return "0" + time;
    }
    return time;
  }
  addEventP( patrolDate: Date, endDate : Date, id, name : string,park : string, info: string): void {   
    this.events = [
      ...this.events,
      {
        title:    name + " ( " + this.getTimeFormat(patrolDate.getHours()+"") +":"+  this.getTimeFormat(patrolDate.getMinutes() + "") + "  -  "+ this.getTimeFormat(endDate.getHours()+"") +":"+  this.getTimeFormat(endDate.getMinutes()+"") + " ) At " + park ,
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

interface reportType{
  patrol?,
  type
}
