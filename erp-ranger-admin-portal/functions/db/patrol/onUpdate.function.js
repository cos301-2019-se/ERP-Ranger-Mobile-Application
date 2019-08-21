const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase');

const db = admin.firestore();

// Score multipliers for day and night
const multiplierDay = 1.0;
const multiplierNight = 1.5;

// Start and end times of days in different seasons based on civil twilight times
const multiplierTimes = [
  [ //SUMMER
    (new Date('1 Dec 2019 05:03:00')),
    (new Date('1 Dec 2019 19:44:00'))
  ],
  [ //SPRING
    (new Date('1 Sep 2019 05:14:00')),
    (new Date('1 Sep 2019 18:48:00'))
  ],
  [ //WINTER
    (new Date('1 Jun 2019 06:39:00')),
    (new Date('1 Jun 2019 18:03:00'))
  ],
  [ //FALL
    (new Date('1 Mar 2019 06:09:00')),
    (new Date('1 Mar 2019 18:20:00'))
  ],
  [ //SUMMER
    (new Date('1 Jan 2019 05:03:00')),
    (new Date('1 Jan 2019 19:44:00'))
  ],
];

/**
 * onUpdate triggers when a user ends their shift and then determines the reward
 * they should receive for their patrol.
 */
exports = module.exports = functions.firestore.document('patrol/{patrolId}').onUpdate((eventSnapshot, context) => {

  if ( // Check if the end field was modified to the correct value
    (eventSnapshot.after.data().end != null) &&
    (eventSnapshot.before.data().end !== eventSnapshot.after.data().end)
  ) {
    const logsRef = db.collection('marker_log')
      .where('patrol', '==', eventSnapshot.before.id);

    return logsRef.get()
      .then((logs) => {
        let reward = 0;
        // Determine the reward and multiplier for each marker visited
        for (let i = 0; i < logs.docs.length; i++) {
          reward += (logs.docs[i].data().reward * calculateMultiplier(logs.docs[i].data().time));
        }
        // Only update users reward if there was a change in reward.
        if (reward != 0) {
          reward = Math.round(reward);
          const rangerRef = db.doc('users/' + eventSnapshot.after.data().user);
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
        }
      })
      .catch((error) => {
        console.error('LogRef Error');
        console.error(error);
      });
  } else {
    return 0;
  }

});

/**
 * This function determines if the provided time is during the day or night
 * and then returns a multiplier based on that
 *
 * @param {*} timestamp
 */
const calculateMultiplier = (timestamp) => {
  const d = timestamp.toDate();
  // Iterate through list of seasons to get the right season
  for (let i = 0; i < multiplierTimes.length; i++) {
    if (d.getMonth() >= multiplierTimes[i][0].getMonth()) {
      const hours = d.getHours();
      const minutes = d.getMinutes();
      if (
        (
          ( // If the hours is the same check minutes
            (hours == multiplierTimes[i][0].getHours()) &&
            (minutes >= multiplierTimes[i][0].getMinutes())
          ) ||
          ( // After hours minutes don't matter
            (hours > multiplierTimes[i][0].getHours())
          )
        ) &&
        (
          ( // If the hours is the same check minutes
            (hours == multiplierTimes[i][1].getHours()) &&
            (minutes <= multiplierTimes[i][1].getMinutes())
          ) ||
          ( // After hours minutes don't matter
            (hours < multiplierTimes[i][1].getHours())
          )
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
