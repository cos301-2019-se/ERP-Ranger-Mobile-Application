import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../../services/user.service';


@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.scss']
})
export class UserListComponent implements OnInit {
  userArr: User[] =[];
  userToDel;
  refresher;
  displayedColumns: string[] = ['id','name','number','email','active','role','points','remaining','edit',
  'delete'
  ];
  constructor(private userService : UserService) { }

  ngOnInit() {
    this.startRefresh();
    this.getUsers();
    
  }

  findUserWithID(id) : string{
    var name = "";
    for(var i =0;i<this.userArr.length;i++){
      if(this.userArr[i].id == id){
        return this.userArr[i].name;
      }
    }


    return name;
  }

  startRefresh(){
    this.refresher = setInterval(function(){this.userArr = this.userArr;},1000)
  }

  stopRefresh(){
    this.refresher = clearInterval();
  }

  deleteConfirm(user){
    this.userToDel = user;
    
    document.getElementById("overlay-confirm-delete").style.visibility = "visible";
    document.getElementById("delete-user").innerHTML=this.findUserWithID(this.userToDel)
    

  }

  hideOverlay(){
    document.getElementById("overlay-confirm-delete").style.visibility = "hidden";

  }

  confirmedDelete(){
    this.userService.deleteUser(this.userToDel);
    this.hideOverlay();
    this.userArr= [];
    this.getUsers();
  }



  getUsers(){
    this.stopRefresh();
    let observer = this.userService.getUsers().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        this.userArr =[...this.userArr,{
          id: change.doc.id,
          name: change.doc.data().name,
          number:change.doc.data().number,
          email:change.doc.data().email,
          active:change.doc.data().active,
          role:change.doc.data().role,
          points:change.doc.data().points,
          remaining:change.doc.data().remaining
        }]
      })
    });
    this.startRefresh();  
  }

}

interface User{
  id: string,
  name:string,
  number:string,
  email:string,
  active:boolean,
  role:string,
  points:string,
  remaining:string
  edit?,
  delete?
}
