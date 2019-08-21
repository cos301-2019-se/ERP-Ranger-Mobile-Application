const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

exports = module.exports = functions.firestore.document('report_types/{typeId}').onDelete((eventSnapshot, context) => {

  /*const markers = db.collection('markers')
    .where('park', '==', eventSnapshot.data().park)
    .where('active', '==', true);

  markers.get().then((result) => {
    db.doc('parks/' + eventSnapshot.data().park).update({
      markers: result.docs.length
    });
  }).catch((error) => {
    console.error('Markers Error');
    console.error(error);
  });
*/
  const promises = [];

  const receiverRef = db.collection('report_type_park_user')
    .where('type', '==', eventSnapshot.id);

  return receiverRef.get()
    .then((results) => {
        results.forEach((document) => {
            promises.push((document) => {
              const data = document.data();
              return database.collection('messages').doc(data.id).delete();
            });
        });
        return Promise.all(promises);
    })
    .then(
      console.info('Successfully deleted all related notifications.')
    )
    .catch((error) => {
      console.error('Failed to delete report notifications.');
      console.error(error);
    });

});
