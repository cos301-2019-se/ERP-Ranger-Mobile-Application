import { Injectable } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import { AngularFireStorage } from '@angular/fire/storage';
import * as firebase from 'firebase';
import { resolve } from 'url';
import { reject } from 'q';

@Injectable({
  providedIn: 'root'
})
export class RewardService {

  constructor(private fireStore: AngularFirestore, private storage: AngularFireStorage) { }

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




  getRewards(){
    return this.fireStore.collection("rewards");
  }
}
