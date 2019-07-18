import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../../services/user.service';


@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.scss']
})
export class UserListComponent implements OnInit {
  userArr: User[] =[];
  displayedColumns: string[] = ['id','name','number','email','active','role'];
  constructor(private userService : UserService) { }

  ngOnInit() {
    this.getUsers();
  }

  getUsers(){
    let observer = this.userService.getUsers().ref
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        this.userArr =[...this.userArr,{
          id: change.doc.id,
          name: change.doc.data().name,
          number:change.doc.data().number,
          email:change.doc.data().email,
          active:change.doc.data().active,
          role:change.doc.data().role
        }]
      })
    });
  }

}

interface User{
  id: string,
  name:string,
  number:string,
  email:string,
  active:boolean,
  role:string
}
