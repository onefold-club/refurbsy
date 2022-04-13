const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require("firebase-admin");

// admin.initializeApp();

admin.initializeApp(functions.config().firebase);

exports.uploadImage = functions.firestore
    .document("tempImgQueue/{docId}")
    .onCreate(async (snap, context) => {
      const newDocData = snap.data();
      const uploadURL = newDocData.uploadURL;
      const docuId = context.params.docId;
      const bucket = admin.storage().bucket();
      const filename = `${docuId}.jpg`;
      const image = bucket.file(filename);
      const resumableUpload = await image.createResumableUpload();
      const uploadUrl = resumableUpload[0];
      console.log(uploadUrl);
      await admin.firestore().collection("tempImgQueue")
          .doc(docuId).update({
            "uploadURL": uploadUrl,
          });
    });

exports.newStorageFile = functions.storage
    .object().onFinalize(async (object) => {
      const filePath = object.name;
      const extension = filePath.split(".")[filePath.split(".").length - 1];
      if (extension != "jpg") {
        return console.log(
            `File extension: ${extension}. 
            This is not an image file. Exiting function.`);
      }

      const imgId = filePath.split(".")[0];
      console.log(`Setting data in firestore doc: ${imgId}`);
      await admin.firestore().collection("tempImgQueue").doc(imgId).update({
        uploadComplete: true,
      });

      console.log(`${imgId}`+": Done");
    });
