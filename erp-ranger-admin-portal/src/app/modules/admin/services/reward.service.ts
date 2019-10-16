import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';
import { resolve } from 'url';
import { reject } from 'q';
import { Reward } from 'src/app/models/Reward.model';

@Injectable({
  providedIn: 'root'
})
export class RewardService {

  constructor(private fireStore: AngularFirestore, private storage: AngularFireStorage) { }


  //adds a reward to the database
  addReward(name, cost, url, imgUrl){
    var self = this;
    this.fireStore.collection('rewards').add({
      id: "",
      name: name,
      cost: cost,
      url: url
    }).then(function(docRef){
      
      self.fireStore.collection('rewards').doc(docRef.id).set({
        id: docRef.id,
        name: name,
        cost: cost,
        url: url
      });

      
      var storageRef = firebase.storage().ref('rewards/' + docRef.id + "/imgProduct");
      console.log(imgUrl);
      var xhr = new XMLHttpRequest();
      xhr.responseType = 'blob';
      xhr.onload = function(event){
        var blob = xhr.response;
        storageRef.put(blob);
      };
      xhr.open('GET', imgUrl);
      xhr.send();
      


      

    })
      
  }

  //returns a reward based on its ID
  getReward(id: String) {
    return this.fireStore.doc<Reward>(`rewards/${id}`).snapshotChanges();
    
  }

  //edits a reward in the database
  setReward(id: String,name:String, cost:String ,url : String,imgUrl: String) {
    var self = this;
    this.fireStore.doc('rewards/'+ id).update({
      name: name,
      cost: cost,
      url: url
    }).then(function(docRef){      
      if(imgUrl != "")
      {
        var storageRef = firebase.storage().ref('rewards/' + id + "/imgProduct");
        console.log(imgUrl);
        var xhr = new XMLHttpRequest();
        xhr.responseType = 'blob';
        xhr.onload = function(event){
          var blob = xhr.response;
          storageRef.put(blob);
        };
        xhr.open('GET', imgUrl+"");
        xhr.send();
      
      }
      


      

    })
    
  }

  //deletes a reward from the database
  deleteReward(id){
    
    this.fireStore.doc('rewards/' + id).delete().then(function(){
      location.reload();
    }).catch(function(err){
      
    });
  }



  //fetches all rewards
  getRewards(){
    return this.fireStore.collection("rewards");
  }
}
