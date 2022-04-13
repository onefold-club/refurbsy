import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:refurbsy/inventory/inventoryBloc/invAirtablePush.dart';
import 'package:refurbsy/models/imgInfo.dart';
import 'package:refurbsy/models/invInfo.dart';

User? user = FirebaseAuth.instance.currentUser;
String userId = user!.uid;

class FirebaseProvider {

  static saveDownloadUrl(String imageName, String invRef, String downloadUrl) async {
    await FirebaseFirestore.instance.collection('inventory').doc(invRef).update({
      'images': FieldValue.arrayUnion([downloadUrl]),
    });
  }

  static deleteFrmTempQ(docID) async {
    await FirebaseFirestore.instance.collection('tempImgQueue').doc(docID).delete();
  }

  static chkforProcessComplete(docID) async {
    await FirebaseFirestore.instance.collection('inventory').doc(docID).get().then((doc) async {
      if(doc.exists){
        var images = (doc.data() as dynamic)['images'];
        var price = (doc.data() as dynamic)['price'];
        if((doc.data() as dynamic)['images'].length == (doc.data() as dynamic)['imagesCount'] && (doc.data() as dynamic)['isSynced'] == false){
          await doc.reference.update({
            'isSynced': true,
          });
          var thumbUrl = (doc.data() as dynamic)['thumbUrl'];
          if (thumbUrl == "" || thumbUrl == "error"){
            var imgURL = images[0];
            await doc.reference.update({
              'thumbUrl': imgURL,
            });
          }
          await AirtableAPI().pushImage(images, price, user);          
        }
      }
    });
  }

  static listenToimages(callback) async {
    FirebaseFirestore.instance.collection('tempImgQueue').where('createdBy',isEqualTo: userId).snapshots().listen((qs) {
      final images = mapQueryToImage_Info(qs);
      callback(images);
    });
  }

  static mapQueryToImage_Info(QuerySnapshot qs) {
    return qs.docs.map((DocumentSnapshot ds) {
      final data = ds.data();
      return Image_Info(
        imageName: ds.id,
        docRef: (data as dynamic)['inventoryRef'],
        finishedProcessing: (data as dynamic)['finishedProcessing'] == true,
        uploadComplete: (data as dynamic)['uploadComplete'] == true,
        uploadUrl: (data as dynamic)['uploadURL'],
        rawimagePath: (data as dynamic)['rawimagePath'],
      );
    }).toList();
  }
}