// FIREBASE
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// SENDGRID
const mail = require('@sendgrid/mail');

// TWILIO
const accountSid = 'AC53139db5f1843928e7ca8837d3a45533';
const authToken = 'ff573958cec2891b03c7b87a3d64efad';
const sms = require('twilio')(accountSid, authToken);

// CONSTANTS
const nl = '\n';
const db = admin.firestore();

/**
 * onCreate triggers when a user submits a report of an incident in the park
 * they should receive for their patrol.
 */
exports = module.exports = functions.firestore.document('reports/{reportId}').onCreate((eventSnapshot, context) => {

  console.info(eventSnapshot.data());
  const reportRef = db.doc('reports/' + eventSnapshot.id);
  return reportRef.get()
    .then((report) => {
      const type = report.data().type;
      // Determine the type and methods used for notification
      const typeRef = db.collection('report_types')
        .where('type', '==', type)
        .limit(1);
      typeRef.get()
        .then((type) => {
          const parkRef = db.doc('parks/' + report.data().park);
          parkRef.get()
            .then((park) => {
              // Determine all the users subscribed to the specific report type
              const usersRef = db.collection('report_type_park_user')
                .where('park', '==', park.id)
                .where('type', '==', type.docs[0].id);
              usersRef.get()
                .then((users) => {
                  for (let i = 0; i < users.docs.length; i++) {
                    console.info(users.docs[i].data().user);//can compact and use data from here for email
                    // Get the users details before sending notification
                    const userRef = db.doc('users/' + users.docs[i].data().user);
                    userRef.get()
                      .then((user) => {
                        // Notify user with different methods
                        if (type.docs[0].data().methods['email']) email(type, park, user.data().email, report);
                        if (type.docs[0].data().methods['sms']) message(type, park, user.data().number, report);
                        if (type.docs[0].data().methods['web']) notify(type, park, null, report);
                        if (type.docs[0].data().methods['api']) api(type, park, null, report);
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

});

/**
 * Notify admins of a report using email
 *
 * @param {*} type
 * @param {*} park
 * @param {*} user
 * @param {*} report
 */
const email = (type, park, user, report) => {
  mail.setApiKey('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');

  let message = 'Park: ' + park.data().name + nl;
  message += 'Type: ' + type.docs[0].data().type + nl;
  message += nl;
  message += 'Location: ' + nl;
  message += 'Lat=' + report.data().location.geopoint.latitude + nl;
  message += 'Lng=' + report.data().location.geopoint.longitude + nl;
  message += nl;
  message += 'Link: https://erp-ranger-app.web.app/admin/report/' + report.id + nl;
  message += nl;
  message += 'Report: ' + nl;
  message += '=====================================' + nl;
  message += report.data().report + nl;

  const html = generateHTML(type, park, report);

  const options = {
    to: user,
    from: 'noreply@erp.ngo',
    subject: type.docs[0].data().type + ' - ' + park.data().name,
    text: message,
    html: html
  };

  mail.send(options)
    .then((result) => {
      console.info(result);
    })
    .catch((error) => {
      console.error(error);
    });
}

/**
 * Notify admins of a report using sms
 *
 * @param {*} type
 * @param {*} park
 * @param {*} user
 */
const message = (type, park, user) => {
  const message = 'New Report: ' + type.docs[0].data().type + ' in ' + park.data().name;

  const options = {
    body: message,
    from: '+19384440161',
    to: user
  };

  sms.messages.create(options)
    .then((result) => {
      console.info(result);
    })
    .catch((error) => {
      console.error(error);
    });
}

/**
 * Notify admins currently on the portal of a report
 *
 * @param {*} type
 * @param {*} park
 * @param {*} users
 */
const notify = (type, park, users) => {
  // Not yet implemented
}

/**
 * Notify another system of an report using a HTTP request
 * @param {*} type
 * @param {*} park
 * @param {*} users
 */
const api = (type, park, users) => {
  // Not yet implemented
}

/**
 * Generate the html email for a report using a template
 *
 * @param {*} type
 * @param {*} park
 * @param {*} report
 */
const generateHTML = (type, park, report) => {
  let html = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">';
  html += '<head><!--[if gte mso 9]><xml><o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><![endif]--><meta content="text/html; charset=utf-8" http-equiv="Content-Type"/><meta content="width=device-width" name="viewport"/><!--[if !mso]><!--><meta content="IE=edge" http-equiv="X-UA-Compatible"/><!--<![endif]--><title>ERP Park Report</title><!--[if !mso]><!--><link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css"/><!--<![endif]-->';
  html += '<style type="text/css">body{margin:0;padding:0}table,td,tr{vertical-align:top;border-collapse:collapse}*{line-height:inherit}a[x-apple-data-detectors=true]{color:inherit!important;text-decoration:none!important}</style>';
  html += '<style id="media-query" type="text/css">@media (max-width:520px){.block-grid,.col{min-width:320px!important;max-width:100%!important;display:block!important}.block-grid{width:100%!important}.col{width:100%!important}.col>div{margin:0 auto}img.fullwidth,img.fullwidthOnMobile{max-width:100%!important}.no-stack .col{min-width:0!important;display:table-cell!important}.no-stack.two-up .col{width:50%!important}.no-stack .col.num4{width:33%!important}.no-stack .col.num8{width:66%!important}.no-stack .col.num4{width:33%!important}.no-stack .col.num3{width:25%!important}.no-stack .col.num6{width:50%!important}.no-stack .col.num9{width:75%!important}.video-block{max-width:none!important}.mobile_hide{min-height:0;max-height:0;max-width:0;display:none;overflow:hidden;font-size:0}.desktop_hide{display:block!important;max-height:none!important}}</style>';
  html += '</head><body class="clean-body" style="margin: 0; padding: 0; -webkit-text-size-adjust: 100%; background-color: #FFFFFF;"><!--[if IE]><div class="ie-browser"><![endif]--><table bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #FFFFFF; width: 100%;" valign="top" width="100%"><tbody><tr style="vertical-align: top;" valign="top"><td style="word-break: break-word; vertical-align: top;" valign="top"><!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#FFFFFF"><![endif]--><div style="background-color:transparent;"><div class="block-grid mixed-two-up no-stack" style="Margin: 0 auto; min-width: 320px; max-width: 500px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: #121B41;"><div style="border-collapse: collapse;display: table;width: 100%;background-color:#121B41;"><!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:500px"><tr class="layout-full-width" style="background-color:#121B41"><![endif]--><!--[if (mso)|(IE)]><td align="center" width="166" style="background-color:#121B41;width:166px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]--><div class="col num4" style="display: table-cell; vertical-align: top; max-width: 320px; min-width: 164px; width: 166px;"><div style="width:100% !important;"><!--[if (!mso)&(!IE)]><!--><div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;"><!--<![endif]--><div align="center" class="img-container center autowidth" style="padding-right: 0px;padding-left: 0px;"><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 0px;padding-left: 0px;" align="center"><![endif]--><img align="center" alt="Image" border="0" class="center autowidth" src="https://images.squarespace-cdn.com/content/57769a79b3db2b767dd94cf3/1473346167430-BC48AHHO1MHD2TOM35JJ/ERP_v2-08.png?content-type=image%2Fpng" style="text-decoration: none; -ms-interpolation-mode: bicubic; border: 0; height: auto; width: 100%; max-width: 100px; display: block;" title="Image" width="100"/><!--[if mso]></td></tr></table><![endif]--></div><!--[if (!mso)&(!IE)]><!--></div><!--<![endif]--></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--><!--[if (mso)|(IE)]></td><td align="center" width="333" style="background-color:#121B41;width:333px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]--><div class="col num8" style="display: table-cell; vertical-align: top; min-width: 320px; max-width: 328px; width: 333px;"><div style="width:100% !important;"><!--[if (!mso)&(!IE)]><!--><div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;"><!--<![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 25px; padding-bottom: 10px; font-family: Tahoma, Verdana, sans-serif"><![endif]--><div style="color:#555555;font-family:Roboto, Tahoma, Verdana, Segoe, sans-serif;line-height:200%;padding-top:15px;padding-right:10px;padding-bottom:5px;padding-left:10px;"><p style="font-size: 12px; line-height: 44px; text-align: center; color: #555555; font-family: Roboto, Tahoma, Verdana, Segoe, sans-serif; margin: 0;">';
  html += '<span style="font-size: 22px; color: #ffffff;">ERP Ranger Application</span>';
  html += '</p></div><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 25px; padding-bottom: 10px; font-family: Tahoma, Verdana, sans-serif"><![endif]--><div style="color:#555555;font-family:Roboto, Tahoma, Verdana, Segoe, sans-serif;line-height:200%;padding-top:0px;padding-right:10px;padding-bottom:10px;padding-left:10px;"><p style="font-size: 12px; line-height: 44px; text-align: center; color: #555555; font-family: Roboto, Tahoma, Verdana, Segoe, sans-serif; margin: 0;">';
  html += '<span style="font-size: 22px; color: #ffffff;">Park Report</span>';
  html += '</p></div><!--[if mso]></td></tr></table><![endif]--><!--[if (!mso)&(!IE)]><!--></div><!--<![endif]--></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--><!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]--></div></div></div><div style="background-color:transparent;"><div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 500px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;"><div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;"><!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:500px"><tr class="layout-full-width" style="background-color:transparent"><![endif]--><!--[if (mso)|(IE)]><td align="center" width="500" style="background-color:transparent;width:500px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]--><div class="col num12" style="min-width: 320px; max-width: 500px; display: table-cell; vertical-align: top; width: 500px;"><div style="width:100% !important;"><!--[if (!mso)&(!IE)]><!--><div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;"><!--<![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]--><div style="color:#555555;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;line-height:120%;padding-top:10px;padding-right:10px;padding-bottom:0px;padding-left:10px;"><div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">';
  html += '<p style="font-size: 18px; line-height: 16px; margin: 0;">Park: ' + park.data().name + '</p>';
  html += '</div></div><!--[if mso]></td></tr></table><![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]--><div style="color:#555555;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;line-height:120%;padding-top:10px;padding-right:10px;padding-bottom:4px;padding-left:10px;"><div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">';
  html += '<p style="font-size: 18px; line-height: 16px; margin: 0;">Type: ' + type.docs[0].data().type + '</p>';
  html += '</div></div><!--[if mso]></td></tr></table><![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]--><div style="color:#555555;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;line-height:120%;padding-top:10px;padding-right:10px;padding-bottom:4px;padding-left:10px;"><div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">';
  html += '<p style="font-size: 18px; line-height: 16px; margin: 0;">Latitude: ' + report.data().location.geopoint.latitude + '</p>';
  html += '</div></div><!--[if mso]></td></tr></table><![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]--><div style="color:#555555;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;line-height:120%;padding-top:0px;padding-right:10px;padding-bottom:10px;padding-left:10px;"><div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">';
  html += '<p style="font-size: 18px; line-height: 16px; margin: 0;">Longitude: ' + report.data().location.geopoint.longitude + '</p>';
  html += '</div></div><!--[if mso]></td></tr></table><![endif]--><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif"><![endif]--><div style="color:#555555;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;line-height:120%;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;"><div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">';
  html += '<p style="font-size: 18px; line-height: 16px; margin: 0;">Report: ' + report.data().report + '</p>';
  html += '</div></div><!--[if mso]></td></tr></table><![endif]--><!--[if (!mso)&(!IE)]><!--></div><!--<![endif]--></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--><!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]--></div></div></div><div style="background-color:transparent;"><div class="block-grid mixed-two-up" style="Margin: 0 auto; min-width: 320px; max-width: 500px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;"><div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;"><!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:500px"><tr class="layout-full-width" style="background-color:transparent"><![endif]--><!--[if (mso)|(IE)]><td align="center" width="333" style="background-color:transparent;width:333px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]--><div class="col num8" style="display: table-cell; vertical-align: top; min-width: 320px; max-width: 328px; width: 333px;"><div style="width:100% !important;"><!--[if (!mso)&(!IE)]><!--><div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;"><!--<![endif]--><div></div><!--[if (!mso)&(!IE)]><!--></div><!--<![endif]--></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--><!--[if (mso)|(IE)]></td><td align="center" width="166" style="background-color:transparent;width:166px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]--><div class="col num4" style="display: table-cell; vertical-align: top; max-width: 320px; min-width: 164px; width: 166px;"><div style="width:100% !important;"><!--[if (!mso)&(!IE)]><!--><div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;"><!--<![endif]--><div align="center" class="button-container" style="padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;"><!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-spacing: 0; border-collapse: collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;"><tr><td style="padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px" align="center"><v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="" style="height:31.5pt; width:99pt; v-text-anchor:middle;" arcsize="10%" stroke="false" fillcolor="#121B41"><w:anchorlock/><v:textbox inset="0,0,0,0"><center style="color:#ffffff; font-family:Arial, sans-serif; font-size:16px"><![endif]-->';
  html += '<a href="https://erp-ranger-app.web.app/admin/report/' + report.id + '"><div style="text-decoration:none;display:inline-block;color:#ffffff;background-color:#121B41;border-radius:4px;-webkit-border-radius:4px;-moz-border-radius:4px;width:auto; width:auto;;border-top:1px solid #121B41;border-right:1px solid #121B41;border-bottom:1px solid #121B41;border-left:1px solid #121B41;padding-top:5px;padding-bottom:5px;font-family:Arial, Helvetica Neue, Helvetica, sans-serif;text-align:center;mso-border-alt:none;word-break:keep-all;"><span style="padding-left:20px;padding-right:20px;font-size:16px;display:inline-block;"><span style="font-size: 16px; line-height: 32px;">View Report</span></span></div></a><!--[if mso]></center></v:textbox></v:roundrect></td></tr></table><![endif]--></div><!--[if (!mso)&(!IE)]><!--></div><!--<![endif]--></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--><!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]--></div></div></div><!--[if (mso)|(IE)]></td></tr></table><![endif]--></td></tr></tbody></table><!--[if (IE)]></div><![endif]--></body></html>';

  return html;
}
