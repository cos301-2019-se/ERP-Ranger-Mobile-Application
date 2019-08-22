const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

/**
 * onDelete triggers when a report type is deleted and then this function deletes
 * all notifications related to that type is deleted.
 */
exports = module.exports = functions.firestore.document('report_types/{typeId}').onDelete((eventSnapshot, context) => {

  const promises = [];

  const receiverRef = db.collection('report_type_park_user')
    .where('type', '==', eventSnapshot.id);

  return receiverRef.get()
    .then((results) => {
      for (let i = 0; i < results.docs.length; i++) {
        promises.push(() => {
          const data = results.docs[i].data();
          return database.collection('messages').doc(data.id).delete();
        });
      }
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
