'use strict'

const glob = require('glob');
const camelCase = require('camelcase');
const functions = require('firebase-functions');
const admin = require('firebase-admin');

const config = functions.config().firebase;
const settings = {
  timestampsInSnapshots: true
};

admin.initializeApp(config);
admin.firestore().settings(settings);

const files = glob.sync('./**/*.function.js', { cwd: __dirname, ignore: './node_modules/**' })
for (let f = 0, fl = files.length; f < fl; f++) {
  const file = files[f];
  const functionName = camelCase(file.slice(0, -12).split('/').join('_'));
  if (!process.env.FUNCTION_NAME || process.env.FUNCTION_NAME === functionName) {
    exports[functionName] = require(file);
  }
}
