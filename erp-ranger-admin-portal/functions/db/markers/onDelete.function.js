const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

/**
 * onDelete triggers when an existing marker is deleted and then counts all the
 * markers in the park and saves it to the park.
 */
exports = module.exports = functions.firestore.document('markers/{markerId}').onDelete((eventSnapshot, context) => {

  const markers = db.collection('markers')
    .where('park', '==', eventSnapshot.data().park)
    .where('active', '==', true);

  return markers.get().then((result) => {
    db.doc('parks/' + eventSnapshot.data().park).update({
      markers: result.docs.length
    });
  }).catch((error) => {
    console.error('Markers Error');
    console.error(error);
  });

});
