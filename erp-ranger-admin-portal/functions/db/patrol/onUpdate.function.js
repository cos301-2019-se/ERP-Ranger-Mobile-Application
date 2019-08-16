const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase');

const db = admin.firestore();

const multiplierDay = 1.0;
const multiplierNight = 1.5;
const multiplierTimes = [ // These day times are based on civil twilight times.
  [ //SUMMER
    (Date.parse('1 Dec 2019 05:03:00 SAST')),
    (Date.parse('1 Dec 2019 19:44:00 SAST'))
  ],
  [ //SPRING
    (Date.parse('1 Sep 2019 05:14:00 SAST')),
    (Date.parse('1 Sep 2019 18:48:00 SAST'))
  ],
  [ //WINTER
    (Date.parse('1 Jun 2019 06:39:00 SAST')),
    (Date.parse('1 Jun 2019 18:03:00 SAST'))
  ],
  [ //FALL
    (Date.parse('1 Mar 2019 06:09:00 SAST')),
    (Date.parse('1 Mar 2019 18:20:00 SAST'))
  ],
  [ //SUMMER
    (Date.parse('1 Jan 2019 05:03:00 SAST')),
    (Date.parse('1 Jan 2019 19:44:00 SAST'))
  ],
];

exports = module.exports = functions.firestore.document('patrol/{patrolId}').onUpdate((eventSnapshot, context) => {

    if (
      (eventSnapshot.data().end != null) &&
      (eventSnapshot.before.data().end !== eventSnapshot.after.data().end)
    ) {
      const logsRef = db.collection('marker_log')
        .where('patrol', '==', eventSnapshot.id);

      return logsRef.get()
        .then((logs) => {
          let reward = 0;
          for (let i = 0; i < logs.docs.length(); i++) {
            reward += (logs.docs[i].data().reward * calculateMultiplier(logs.docs[i].data().time));
          }
          reward = Math.round(reward);
          const rangerRef = db.doc('users/' + eventSnapshot.data().user);
          rangerRef.get()
            .then((ranger) => {
              const total = ranger.data().points + reward;
              const remain = ranger.data().remaining + reward;
              rangerRef.update({
                points: total,
                remaining: remain
              });
            })
            .catch((error) => {
              console.error('RangerRef Error');
              console.error(error);
            });
        })
        .catch((error) => {
          console.error('LogRef Error');
          console.error(error);
        });
    }

});

const calculateMultiplier = (timestamp) => {
  const d = timestamp.toDate();
  for (let i = 0; i < multiplierTimes.length; i++) {
    if (d.getMonth() >= multiplierTimes[i][0].getMonth()) {
      const hours = d.getHours();
      const minutes = d.getMinutes();
      if (
        (
          (hours >= multiplierTimes[i][0].getHours()) &&
          (minutes >= multiplierTimes[i][0].getMinutes())
        ) &&
        (
          (hours <= multiplierTimes[i][1].getHours()) &&
          (minutes <= multiplierTimes[i][1].getMinutes())
        )
      ) {
        return multiplierDay;
      } else {
        return multiplierNight;
      }
    }
  }
  return multiplierDay;
}
