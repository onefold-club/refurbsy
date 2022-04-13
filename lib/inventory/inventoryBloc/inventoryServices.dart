import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;

class InvServices {
  var firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future updateStatusSold(docID) async {
    await firebase
        .collection('inventory')
        .doc(docID)
        .update({'status': 'Sold'});
  }

  Future uploadThumb(String filePath) async {
    File file = File(filePath);
    String url;
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/')
          .child('inventory/')
          .child('thumb/')
          .child('${DateTime.now()}');
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      await uploadTask;
      url = await uploadTask.snapshot.ref.getDownloadURL();
      return url;
    } on FirebaseException {
      return 'error';
    }
  }

  Future addInventory(
      List<String> imgUrls,
      List images,
      String price,
      String brand,
      String type,
      String dimension,
      String color,
      String condition,
      String compID) async {
    // List imgUrls = [];

    final tempDir = await getTemporaryDirectory();
    // final tempDir = await getApplicationSupportDirectory();
    final path = tempDir.path;

    // final dir = Platform.isAndroid
    // ? await getExternalStorageDirectory()
    // : await getApplicationSupportDirectory();
    // final imageFldr = '${dir!.path}/Inventory_Img';

    // if (await Directory(imageFldr).exists() != true) {
    //   await Directory(imageFldr).create();
    // }

    // for(File img in images){

    //   im.Image? image = im.decodeImage((img).readAsBytesSync());
    //   var newImgFile = File("$imageFldr/image_${DateTime.now()}.jpg")
    //   ..writeAsBytesSync(im.encodeJpg(image!, quality: 50));
    //   imgUrls.add(newImgFile.path);

    //   // print(imgUrls.toString());
    // }

    // for(var img in images){
    print('IMAGES COUNT: ${images.length}');
    im.Image? image = im.decodeImage((images[0]).readAsBytesSync());

    var cImage = File('$path/img_${DateTime.now()}.jpg')
      ..writeAsBytesSync(im.encodeJpg(image!, quality: 5));

    var thumbUrl = await uploadThumb(cImage.path);

    await firebase.collection('inventory').add({
      'brand': brand,
      'color': color,
      'condition': condition,
      'company_id': compID,
      'price': price,
      'status': 'Available',
      'type': type,
      'images': [],
      'imagesCount': imgUrls.length,
      'lclImages': imgUrls,
      'thumbUrl': thumbUrl,
      'isSynced': false,
      'isProcessed': false,
      'createdDt': DateTime.now(),
      'createdBy': user!.uid,
    }).then((doc) async {
      for (var img in imgUrls) {
        await firebase.collection('tempImgQueue').add({
          'rawimagePath': img,
          // 'finishedProcessing': false,
          'uploadComplete': false,
          'inventoryRef': doc.id,
          'createdBy': user!.uid,
        });
      }
    });

    // await Workmanager().registerOneOffTask(
    //   "1",
    //   uploadFileTask,
    //   inputData: <String, dynamic>{
    //     'filesPath': imgUrls,
    //   },
    //   constraints: Constraints(
    //     networkType: NetworkType.connected,
    //     requiresBatteryNotLow: true,
    //   ),
    //   backoffPolicy: BackoffPolicy.exponential,
    //   existingWorkPolicy: ExistingWorkPolicy.keep,

    // );

    // await AirtableAPI().pushImage(imgUrls, price, user);
  }
}
