const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

/*const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;*/

const gmailEmail = 'erprangers@gmail.com';
const gmailPassword = '';

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

  console.info(eventSnapshot.data());
  const reportRef = db.doc('reports/' + eventSnapshot.id);
  reportRef.get()
    .then((report) => {
      console.info(report.data());
      const type = report.data().type;
      const typeRef = db.collection('report_types')
        .where('type', '==', type)
        .limit(1);
      typeRef.get()
        .then((type) => {
          const parkRef = db.doc('parks/' + report.data().park);
          parkRef.get()
            .then((park) => {
              const usersRef = db.collection('report_type_park_user')
                .where('park', '==', park.id)
                .where('type', '==', type.docs[0].id);
              usersRef.get()
                .then((users) => {
                  for (let i = 0; i < users.docs.length; i++) {
                    console.info(users.docs[i].data().user);//can compact and use data from here for email
                    const userRef = db.doc('users/' + users.docs[i].data().user);
                    userRef.get()
                      .then((user) => {
                        console.info(user.data());
                        if (type.docs[0].data().methods['email']) email(type, park, user.data().email, report);
                        if (type.docs[0].data().methods['sms']) sms(type, park, user.data().number, report);
                        if (type.docs[0].data().methods['notification']) notify(type, park, null, report);
                      })
                      .catch((error) => {
                        console.error('UserRef Error');
                        console.error(error);
                      });
                  }
                })
                .catch((error) => {
                  console.error('UsersRef Error');
                  console.error(error);
                });
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

const email = (type, park, user, report) => {
  let options = {}
  options.from = 'erprangers@gmail.com';
  options.subject = type.docs[0].data().type + ' - ' + park.data().name;

  options.to = user;

  options.text = 'Park: ' + park.data().name + nl;
  options.text += 'Type: ' + type.docs[0].data().type + nl;
  options.text += nl;
  options.text += 'Location: ' + nl;
  options.text += 'Lat=' + report.data().location.geopoint.latitude + nl;
  options.text += 'Lng=' + report.data().location.geopoint.longitude + nl;
  options.text += nl;
  options.text += 'Link: https://erp-ranger-app.web.app/admin/report/' + report.id + nl;
  options.text += nl;
  options.text += 'Report: ' + nl;
  options.text += '=====================================' + nl;
  options.text += report.data().report + nl;

  mailTransport.sendMail(options)
    .then((result) => {
      console.info('Report email sent successfully:' + options.to);
    })
    .catch((error) => {
      console.error('There was an error while sending the email: ' + error);
    });
}

const sms = (type, park, users) => {}

const notify = (type, park, users) => {}

const api = (type, park, users) => {}
