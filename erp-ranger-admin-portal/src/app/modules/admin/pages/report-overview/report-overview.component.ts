import { Component, OnInit, ViewChild } from '@angular/core';
import { MouseEvent } from '@agm/core';
import { ReportService } from '../../services/report.service';
import { Park } from 'src/app/models/Park.model';
import { MatTableDataSource } from '@angular/material/table';
import { ShiftService } from '../../services/shift.service';
import { MatPaginator, MatSort } from '@angular/material';
import { ParkService } from 'src/app/services/park.service';
import { FormControl, FormGroup } from '@angular/forms';



@Component({
  selector: 'app-report-overview',
  templateUrl: './report-overview.component.html',
  styleUrls: ['./report-overview.component.scss']
})
export class ReportOverviewComponent implements OnInit {

  // Set initial zoom intensity
  /*zoom: number = 13;*/
  park: Park;

  // Default map load location - currently Rietvlei dam TODO change to be dynamic
  /*lat: number = -25.876910;
  lng: number = 28.273253;*/
  // tslint:disable-next-line: max-line-length
  // kml = 'https://gist.githubusercontent.com/Jtfnel/77b53014741ec9fce2ffc68d210cdf56/raw/cd8d5bbf2476c48512cb6d44694a52289aa52999/rietvlei.kml';
  defaultui;
  reportArr :  reportRow[] = [];
  markers;
  dataSource = new MatTableDataSource(this.reportArr);
  displayedColumns: string[] = ['type', 'park','time','ranger','handled'];
  typeFilter = new FormControl('');
  genFilter = new FormControl ('');
  rangerFilter = new FormControl ('');
  dayFilter = new FormControl ('');
  monthFilter = new FormControl ('');
  yearFilter = new FormControl ('');
  handled = new FormGroup({
    handledBool: new FormControl()
  });
  hBool = true;
  filterValues = {
    type : '',
    reportInfo : '',
    ranger: '',
    day:'',
    month:'',
    year:'',
    handled:''
  };

  @ViewChild(MatPaginator) paginator:MatPaginator;
  @ViewChild(MatSort) sort:MatSort;

  constructor(private reports: ReportService,private shifts:ShiftService, private parks: ParkService) {
    this.dataSource.data = this.reportArr;
    this.dataSource.filterPredicate = this.tableFilter();
  }

  ngOnInit() {
    this.typeFilter.valueChanges
      .subscribe(
        type => {
          this.filterValues.type = type.toLowerCase();          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.genFilter.valueChanges
      .subscribe(
        info => {
          this.filterValues.reportInfo = info.toLowerCase();          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.rangerFilter.valueChanges
      .subscribe(
        ranger => {
          this.filterValues.ranger = ranger.toLowerCase();          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.dayFilter.valueChanges
      .subscribe(
        day => {
          this.filterValues.day = day;          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.monthFilter.valueChanges
      .subscribe(
        month => {
          this.filterValues.month = month;          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.yearFilter.valueChanges
      .subscribe(
        year => {
          this.filterValues.year = year;          
          this.dataSource.filter = JSON.stringify(this.filterValues);
        }
      );
      this.handled.valueChanges.subscribe( handled => {
        this.filterValues.handled = handled.handledBool;
        this.dataSource.filter = JSON.stringify(this.filterValues);
      })
    this.park = this.parks.getParkLocal(); 
    // this.setSize();
    this.displayReports();
  }

  timeToString(d: Date){
    return (d+"").substring(0,(d+"").indexOf("GMT")-1);
  }

  tableFilter(): (data: any, filter: string) => boolean {
    let filterFunction = function(data, filter): boolean {
      let searchTerms = JSON.parse(filter);
      var d = new Date (data.time);    
      var day = d.getDate();
      var month = d.getMonth()+1;
      var year = d.getFullYear();        
      return data.type.toLowerCase().indexOf(searchTerms.type) !== -1        
      && data.reportInfo.toLowerCase().indexOf(searchTerms.reportInfo) !==-1
      && data.ranger.toLowerCase().indexOf(searchTerms.ranger) !==-1
      && ((day == searchTerms.day) || !(searchTerms.day))
      && ((month == searchTerms.month) || !(searchTerms.month))
      && ((year == searchTerms.year) || !(searchTerms.year))
      && ((data.handled == false)|| (searchTerms.handled == true))
    }
    return filterFunction;
  } 
  
  


  // Retrieve all reports submitted to the database and add all markers to the map
  displayReports() {
    this.reports.getReports().subscribe(result => {      
      this.markers = result;
      this.reportArr = [];
      for (let i = 0; i < result.length; i++) {
        var parkID = String(result[i].payload.doc.data()['park']);
        var userID = String(result[i].payload.doc.data()['user']);
        let docRef = this.shifts.getUserName(userID);        
        let getUser = docRef.get()
        .then(userDoc => {
          if(!result){
            console.log("User not found ");
            
          } else{     
            var userName = userDoc.data().name;
            let docRef = this.shifts.getParkName(parkID);        
            let getPark = docRef.get()
            .then(parkDoc => {
              if(!parkDoc.exists){
                console.log("Park not found ");
                
              } else{    
                if (parkID == this.park.id ){                  
                    var d = new Date(result[i].payload.doc.data()['time'].toDate());
                    var da = (d+"").substring(0,(d+"").indexOf("GMT")-1);
                    var parkName = parkDoc.data().name;               
                    this.reportArr[i] = {
                      id: String(result[i].payload.doc.id),
                      park: parkName,
                      time: d,
                      ranger: userName,
                      type: String(result[i].payload.doc.data()['type']),
                      reportInfo : String(result[i].payload.doc.data()['report']),
                      handled: result[i].payload.doc.data()['handled']
                    };
                  
                    this.dataSource.data = this.reportArr;
                    this.dataSource = new MatTableDataSource(this.reportArr);
                    this.dataSource.sort = this.sort;
                    this.dataSource.paginator = this.paginator;
                    this.dataSource.filterPredicate = this.tableFilter();
                  }
                }
            })
            .catch(err => {
              console.log("Error getting document");         
            });
          }
        })
        .catch(err => {
          console.log("Error getting document" + err);         
        });

        
      }      
    });
    
  }

  // Set size of AGM map
  /*setSize(){
    document.getElementById("map-agm").style.height = (document.body.offsetHeight-32) + "px";
  }*/

  //Applies filter to table
  search(filterVal: string){
    this.dataSource=this.dataSource;
    this.dataSource.filter = filterVal.trim().toLowerCase();
    if(this.dataSource.paginator){
      this.dataSource.paginator.firstPage();
    }
  }

}
export interface reportRow{
  id,
  park: string,
  time:Date,
  ranger:string,
  type:string,
  reportInfo:string,
  handled:boolean
}