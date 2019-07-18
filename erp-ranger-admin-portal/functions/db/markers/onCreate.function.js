const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

exports = module.exports = functions.firestore.document('markers/{markerId}').onCreate((eventSnapshot, context) => {

  const markers = db.collection('markers')
    .where('park', '==', eventSnapshot.data().park)
    .where('active', '==', true);

  markers.get().then((result) => {
    db.doc('parks/' + eventSnapshot.data().park).update({
      markers: result.docs.length
    });
  }).catch((error) => {
    console.log(error);
  });

  return 0;

});
