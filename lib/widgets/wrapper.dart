import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:provider/provider.dart';
import 'package:refurbsy/auth/login.dart';
import 'package:refurbsy/inventory/inventory.dart';
import 'package:refurbsy/inventory/inventoryBloc/invAirtablePush.dart';
import 'package:refurbsy/models/imgInfo.dart';
import 'package:refurbsy/models/invInfo.dart';
import 'package:refurbsy/widgets/global.dart';
import 'package:refurbsy/widgets/spinner.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;

import '../inventory/inventoryBloc/firebaseprovider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  String compID = '';
  bool loading = true;

  // List<Image_Info> _images = <Image_Info>[];
  final FlutterUploader _uploader = FlutterUploader();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    loadVars();
    _initializebguploader();
    // _initializeinvupdater();
  }

  Future loadVars() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((doc){
      compID = (doc.data() as dynamic)['company_id'];
    });
    await Provider.of<CurrentUser>(context, listen: false).changeUser(user);
    await Provider.of<CompID>(context, listen: false).changeCompID(compID);
    setState((){loading = false;});
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {return const Loading();}
    if (compID != ''){
      return const InventoryPage(); //LandingPage();
    } else {
      return const LoginPage();
    }
  }

  _initializebguploader() async {

    await Firebase.initializeApp();

    FirebaseProvider.listenToimages((List<Image_Info> newImages) {
      for (Image_Info image in newImages) {
        if (image.uploadComplete!) {
          _saveDownloadUrl(image);
        } else if (!image.uploadComplete! && image.uploadUrl != null) {
          _uploadImage(image);
        }
      }
    });
  }

  // _initializeinvupdater() async {

  //   await Firebase.initializeApp();

  //   FirebaseProvider.listenToInvs((List<Inv_Info> updatedInvs) {
  //     for (Inv_Info inventory in updatedInvs) {
  //       if (inventory.imgCount == inventory.imgUrls!.length) {
  //         _deletefrmTempQ(inventory.docRef);
  //         _updateisSync(inventory.docRef);
  //         _chkThumbNail(inventory.docRef);         
  //         _pushToAirTable(inventory.docRef);
  //       }
  //     }
  //   });
  // }

  Future<String> _uploadFileBackground(filePath, uploadUrl) async {
    
    const tag = 'upload';

    final upload = RawUpload(
      url: uploadUrl,
      path: filePath,
      method: UploadMethod.PUT,
      tag: tag,
    );
    try{
     return await _uploader.enqueue(upload);
    }catch(e){
      print(e.toString());
      return 'FAILED';
    }
  }

  Future<void> _saveDownloadUrl(Image_Info image) async {
    final fbs.Reference ref =
        fbs.FirebaseStorage.instance.ref().child('${image.imageName}.jpg');

    String url = await ref.getDownloadURL();
    await FirebaseProvider.saveDownloadUrl(image.imageName!, image.docRef!, url);
    await FirebaseProvider.deleteFrmTempQ(image.imageName);
    await FirebaseProvider.chkforProcessComplete(image.docRef);
  }

  Future<void> _uploadImage(Image_Info image) async {
    await _uploadFileBackground(image.rawimagePath, image.uploadUrl);
  }
}