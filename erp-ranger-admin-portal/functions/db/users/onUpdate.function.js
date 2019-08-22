const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase');

const db = admin.firestore();



/**
 * onUpdate triggers when a user is deleted and deletes the user from auth if this isthe case
 * 
 */
exports = module.exports = functions.firestore.document('users/{userId}').onUpdate((eventSnapshot, context) => {
      if(eventSnapshot.after.data().active == false){
            admin.auth().deleteUser(eventSnapshot.before.id);    
      }
      
  

});

