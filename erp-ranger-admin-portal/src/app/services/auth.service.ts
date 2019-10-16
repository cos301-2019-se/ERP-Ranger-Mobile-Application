import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { auth } from 'firebase';
import { AngularFireAuth } from '@angular/fire/auth';
import { AngularFirestore } from '@angular/fire/firestore';
import { Observable, of } from 'rxjs';
import { switchMap, map, tap } from 'rxjs/operators';
import { User } from '../models/User.model';
import { UserService } from './user.service';
import { ParkService } from './park.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  isLoggedIn: boolean;
  user: Observable<User | null>;

  constructor(
    private fireAuth: AngularFireAuth,
    private fireStore: AngularFirestore,
    private router: Router,
    private u: UserService,
    private p: ParkService
  ) {
    this.user = this.fireAuth.authState.pipe(
      switchMap(user => {
        if (user) {
          this.isLoggedIn = true;
          let temp = this.fireStore.doc<User>(`users/${user.uid}`).valueChanges();
          //this.setupSession(user.uid);
          /*temp.subscribe(result => {
            if(result.role == "Admin") {
              this.router.navigate(['/admin']);
            } else if(result.role == "Ranger") {
              this.router.navigate(['/ranger']);
            }
          });*/
          return temp;
        } else {
          return of(null);
        }
      }),
      tap(user => localStorage.setItem('user', JSON.stringify(user))),
    );
  }

  login(email: string, password: string) {
    return this.fireAuth.auth
      .signInWithEmailAndPassword(email, password)
      .then(credential => {
        localStorage.setItem('user', JSON.stringify(credential.user.uid));
        this.p.getParks(1).subscribe(response => {
          const park = response[0].payload.doc.data();
          this.p.setParkLocal(park);
          this.setupSession(credential.user.uid);
        });
      })
      .catch(error => this.handleError(error));
  }

  logout() {
    this.fireAuth.auth.signOut().then(() => {
      this.p.deleteParkLocal();
      this.router.navigate(['/']);
    });
    location.reload();
  }

  setupSession(uid: String) {
    this.u.getUser(uid).subscribe(response => {
      //TODO: Solve circular json problem
      if(response == null) {
        return;
      }
      var udata = {};
      /*console.log(response.payload.data().active);
      console.log(response.payload.data().name);*/
      udata['active'] = response.payload.data().active;
      udata['email'] = response.payload.data().email;
      udata['name'] = response.payload.data().name;
      udata['number'] = response.payload.data().number;
      udata['role'] = response.payload.data().role;
      udata['uid'] = response.payload.data().uid;
      /*console.log(udata['name']);
      console.log(JSON.stringify(udata));*/
      localStorage.setItem('data', JSON.stringify(udata));
      if(response.payload.data().role == "Admin") {
        console.log("Welcome Admin!");
        this.router.navigate(['/admin']);
      } else if(response.payload.data().role == "Ranger") {
        console.log("Welcome Ranger!");
        this.router.navigate(['/ranger']);
      } else {
        this.logout();
      }
    });
  }

  resetPassword(email: string) {
    const fbAuth = auth();
    return fbAuth
      .sendPasswordResetEmail(email)
      .then(() => console.log('Password reset email has been sent'))
      .catch(error => this.handleError(error));
  }

  private route() {
    this.user.subscribe(result => {
      if(result.role == "Admin") {
        this.router.navigate(['/admin']);
      } else if(result.role == "Ranger") {
        this.router.navigate(['/ranger']);
      } else {
        this.logout();
      }
    });
  }

  private handleError(error: Error) {
    console.error(error);
  }

  isAuthenticated() {
    return this.fireAuth.authState.pipe(
      map(user => {
        if(user) {
          return true;
        } else {
          this.router.navigate(['/']);
          return false;
        }
      })
    );
  }

  isNotAuthenticated() {
    return this.fireAuth.authState.pipe(
      map(user => {
        if(user) {
          this.route();
          return false;
        } else {
          return true;
        }
      })
    );
  }

  isAdmin() {
    return this.fireAuth.authState.pipe(
      map(user => {
        if(user) {
          this.user.subscribe(result => {
            if(result.role == "Admin") {
              console.log("isAdmin");
              return true;
            } else {
              return false;
            }
          });
        } else {
          return false;
        }
      })
    );
  }

  isRanger() {
    return this.fireAuth.authState.pipe(
      map(user => {
        if(user) {
          this.user.subscribe(result => {
            if(result.role == "Ranger") {
              console.log("isRanger");
              return true;
            } else {
              return false;
            }
          });
        } else {
          return false;
        }
      })
    );
  }

}
