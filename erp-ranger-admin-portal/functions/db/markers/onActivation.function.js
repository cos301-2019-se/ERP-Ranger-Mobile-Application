const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

/**
 * onActivation triggers when a marker is activated by a ranger and then assigns the points
 * to the ranger as a reward and then redistributing the reward amongst other markers inside
 * the park.
 */
exports = module.exports = functions.firestore.document('marker_log/{logId}').onCreate((eventSnapshot, context) => {

  console.info(eventSnapshot.data());
  const markerRef = db.doc('markers/' + eventSnapshot.data().marker);
  return markerRef.get()
    .then((marker) => {
      const score = marker.data().points;
      if (score > 0) {
        const parkRef = db.doc('parks/' + marker.data().park);
        parkRef.get()
          .then((park) => {
            // Calculate the amount of points that are going to be added to other markers
            const count = park.data().markers;
            let tempScore = score;
            let points = new Array(count - 1);
            for (let i = 0; i < points.length; i++) {
              points[i] = 0;
            }
            while (tempScore > 0) {
              for (let i = 0; (i < points.length) && (tempScore > 0); i++) {
                points[i] = points[i] + 1;
                tempScore = tempScore - 1;
              }
            }

            // Add the points to each marker in the park
            const markersRef = db.collection('markers')
              .where('park', '==', marker.data().park)
              .where('active', '==', true);
            markersRef.get()
              .then((markers) => {
                let j = 0;
                // Loop through all the markers and distribute points.
                for (let i = 0; (i < markers.docs.length) && (j <= points.length); i++) {
                  let value = 0;
                  if (markers.docs[i].id != marker.data().id) {
                    value = points[j];
                    j++;
                    db.doc('markers/' + markers.docs[i].id).get()
                      .then((otherMarker) => {
                        let newPoints = parseInt(otherMarker.data().points) + value;
                        db.doc('markers/' + markers.docs[i].id)
                          .update({
                            points: newPoints
                          });
                      })
                      .catch((error) => {
                        console.error('OtherMarkerRef Error');
                        console.error(error);
                      });
                  } else { // If it is the marker that was activated set it to zero points
                    db.doc('markers/' + markers.docs[i].id)
                      .update({
                        points: 0
                      });
                  }
                }
              })
              .catch((error) => {
                console.error('MarkersRef Error');
                console.error(error);
              });

            // Applying the reward to the marker log file so it can be added to the users points
            db.doc('marker_log/' + eventSnapshot.id).update({
              reward: score
            });
          })
          .catch((error) => {
            console.error('ParkRef Error');
            console.error(error);
          });
      } else {
        console.info('Marker has points of 0');
        return 0;
      }
    })
    .catch((error) => {
      console.error('MarkerRef Error');
      console.error(error);
    });

});
