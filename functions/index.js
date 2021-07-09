const functions = require("firebase-functions");

exports.createUser = functions.firestore
    .document('chat/{message}')
    .onCreate((snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = snap.data();
      console.log(newValue);

      // access a particular field as you would any JS property
//      const name = newValue.name;
//
      // perform desired operations ...
    });

