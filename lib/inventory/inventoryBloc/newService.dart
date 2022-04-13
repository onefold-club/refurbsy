import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

class AsyncService {

  User? user = FirebaseAuth.instance.currentUser;
  var firebase = FirebaseFirestore.instance;
  FlutterUploader imgUpload = FlutterUploader();

  void backgroundHandler() {
    // Needed so that plugin communication works.
    WidgetsFlutterBinding.ensureInitialized();

    // This uploader instance works within the isolate only.
    FlutterUploader uploader = FlutterUploader();

    // You have now access to:
    uploader.progress.listen((progress) {
      print(progress.toString());
    });
    uploader.result.listen((result) {
      print(result);
    });
}

  Future asyncAddInventory(List images, String price, String brand, String type, String dimension, String color, String condition, String compID) async {

    String docID = '';
    String uploadURL = '';
    List<FileItem> fileList = [];

    try{
      await firebase.collection('temp_inventories').add({
          'brand': brand,
          'color': color,
          'condition': condition,
          'company_id': compID,
          'price': price,
          'status': 'Available',
          'type': type,
          'images': [],
          'uploadURL': '',
          'createdDt' : DateTime.now(),
      }).then((doc) {
        docID = doc.id;
      });

      print('DOCID: $docID');

      // for(var img in images){
      //   fileList.add(FileItem(filename: DateTime.now().toString(), savedDir: img));
      // }

      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('temp_inventories').doc(docID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasData){
          var doc = snapshot.data;
          var taskId;
          if ((doc!.data() as dynamic)['uploadURL'] != '') {
            
            uploadURL = (doc.data() as dynamic)['uploadURL'];

            print('UPLOAD URL: $uploadURL');

            FlutterUploader().setBackgroundHandler(backgroundHandler);

            taskId = FlutterUploader().enqueue(
              MultipartFormDataUpload(
                url: "your upload link", //required: url to upload to
                files: [FileItem(path: uploadURL, field:images[0])], // required: list of files that you want to upload
                method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
                // headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
                // data: {"name": "john"}, // any data you want to send in upload request
                // tag: 'my tag', // custom tag which is returned in result/progress
              ),
            );

            print('TASK ID : $taskId');

            
          }
          return taskId;
          } return Container();
        });
        

          } catch(e){
            print(e.toString());
          }
  }
}