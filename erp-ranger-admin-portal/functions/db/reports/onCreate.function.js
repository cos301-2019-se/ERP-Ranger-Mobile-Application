const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const mailTransport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

const nl = '\n';
const db = admin.firestore();

exports = module.exports = functions.firestore.document('reports/{reportId}').onCreate((eventSnapshot, context) => {


  /*const snapshot = change.after;
  const val = snapshot.val();
  if (!snapshot.changed('subscribedToMailingList')) {
    return null;
  }
  const mailOptions = {
    from: '"Spammy Corp." <noreply@firebase.com>',
    to: val.email,
  };
  const subscribed = val.subscribedToMailingList;
  mailOptions.subject = subscribed ? 'Thanks and Welcome!' : 'Sad to see you go :`(';
  mailOptions.text = subscribed ?
      'Thanks you for subscribing to our newsletter. You will receive our next weekly newsletter.' :
      'I hereby confirm that I will stop sending you the newsletter.';

  try {
    await mailTransport.sendMail(mailOptions);
    console.log(`New ${subscribed ? '' : 'un'}subscription confirmation email sent to:`, val.email);
  } catch(error) {
    console.error('There was an error while sending the email:', error);
  }*/

  const reportRef = db.doc('reports/' + eventSnapshot.data().id);
  reportRef.get()
    .then((report) => {
      const type = eventSnapshot.data().type;
      const typeRef = db.collection('report_types')
        .where('type', '==', type);
      typeRef.get()
        .then((type) => {
          const parkRef = db.doc('parks/' + report.data().park);
          parkRef.get()
            .then((park) => {
              let users = {};
              if (type.data().methods['email']) email(type, park, users, report);
              if (type.data().methods['sms']) sms(type, park, users, report);
              if (type.data().methods['notification']) notify(type, park, users, report);
            })
            .catch((error) => {
              console.error('ParkRef Error');
              console.error(error);
            });
        })
        .catch((error) => {
          console.error('This type does not exist.');
          console.error(error);
        });
    })
    .catch((error) => {
      console.error('ReportRef Error');
      console.error(error);
    });

  return 0;

});

const email = (type, park, users, report) => {
  let options = {}
  options.from = 'erprangers@gmail.com';
  options.subject = type.data().type + ' - ' + park.data().name;
  options.text = 'Park: ' + park.data().name + nl;
  options.text += '' + nl;
  options.text += '' + nl;
  options.text += 'Report: ' + report.data().report + nl;
  options.text += nl;
  options.text += 'Location: (Lat) ' + report.data().location.geopoint.latitude
  options.text += '(Lng) ' + report.data().location.geopoint.longitude
}

const sms = (type, park, users) => {}

const notify = (type, park, users) => {}
