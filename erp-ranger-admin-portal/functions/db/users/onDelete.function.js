const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase');

const db = admin.firestore();



/**
 * onUpdate triggers when a user is deleted and deletes the user from auth if this isthe case
 * 
 */
exports = module.exports = functions.firestore.document('users/{userId}').onDelete((eventSnapshot, context) => {
      admin.auth().deleteUser(eventSnapshot.id);    
      
  

});

