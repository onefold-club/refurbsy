
// import 'dart:io';
// // import 'dart:math' as math;
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// // import 'package:refurbsy/auth/fire_auth.dart';
// import 'package:refurbsy/inventory/completedscreen.dart';
// import 'package:refurbsy/inventory/inventoryBloc/inventoryServices.dart';
// import 'package:refurbsy/widgets/global.dart';
// import 'package:refurbsy/widgets/spinner.dart';

// class AddInv extends StatefulWidget {
//   const AddInv({ Key? key }) : super(key: key);

//   @override
//   _AddInvState createState() => _AddInvState();
// }

// // class _AddInvState extends State<AddInv> with SingleTickerProviderStateMixin {
// class _AddInvState extends State<AddInv>{
//   // late final AnimationController _animcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

//   List<CameraDescription> cameras = [];
//   late CameraController _cameraController;
//   TextEditingController priceController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   List<File> capturedImages = [];
//   List<File> syncImages = [];
//   late Rect rect;
//   bool loading = true;
//   bool inProg = false;
//   final picker = ImagePicker();

//   String brand = '';
//   String type = '';
//   String dimension = '';
//   String color = '';
//   String condition = '';
//   String price = '';
//   String syncPrice = '';

//   @override
//   void initState(){
//     getCameraControl();
//     super.initState();
//   }

//   Future getCameraControl() async {
//     await getCameras();
//     await setController();
//   }

//   Future getCameras() async {
//     cameras = await availableCameras();
//   }

//   Future setController() async {
//     _cameraController = CameraController(cameras[0], ResolutionPreset.max);
//     await _cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   Future takePicture() async {
//     setState((){inProg = true;});
//     if (_cameraController.value.isInitialized && !_cameraController.value.isTakingPicture) {
//       _cameraController.setFlashMode(FlashMode.off);
//       XFile xFile = await _cameraController.takePicture();
//       setState(() {
//         capturedImages.add(File(xFile.path));
//       });
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//     setState((){inProg = false;});
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     // _animcontroller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     var _scrH = MediaQuery.of(context).size.height;
//     var _scrW = MediaQuery.of(context).size.width;
//     // var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
//     var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

//     // var _scrH = __scrH - _padV - kToolbarHeight;
//     var scrW = _scrW - _padH;

//     // var currUser = Provider.of<CurrentUser>(context).currUser;
//     var compID = Provider.of<CompID>(context).compID;
//     // var dtSync = Provider.of<DataSync>(context).dataSync;

//     // return StreamBuilder<DataSync>(
//     //   stream: AuthService().syncStatus,
//     //   builder: (context, snapshot) {
//     //     if (snapshot.hasData) {
//           // DataSync? dataSync = snapshot.data;
//           // var dtSync = dataSync!.isSync;
//           return loading ? const Loading() : Scaffold(
//             backgroundColor: Colors.transparent,
//             // bottomNavigationBar: BottomAppBar(
//             //   elevation: 10.0,
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//             //     child: SizedBox(
//             //       width: scrW * 0.8,
//                   // height: _scrH * 0.05,
//                   // child: ElevatedButton(
//                   //   child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18.0),),
//                   //   style: ElevatedButton.styleFrom(
//                   //     shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.circular(30.0),
//                   //     ),
//                   //   ),
//                   //   onPressed: () async {
//                   //     FocusScope.of(context).unfocus();
//                   //     if(capturedImages.isNotEmpty){
//                   //       if(_formKey.currentState!.validate()){
//                   //         syncImages = List.from(capturedImages);
//                   //         syncPrice = price;
//                   //         priceController.text = '';
//                   //         capturedImages.clear();
//                   //         // print('No. of images: ${syncImages.length}');
//                   //         await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SuccessScreen()));
//                   //         InvServices().addInventory(syncImages, syncPrice, brand, type, dimension, color, condition, compID);
//                   //       }
//                   //     } else {
//                   //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add one or more product images and retry')));
//                   //     }
//                   //   }
//                   // ),
//             //     ),
//             //   )
//             // ),
//             body: SingleChildScrollView(
//               child: SizedBox(
//                 height: _scrH,
//                 child: Stack(
//                   children: [
//                     Container(
//                       // height: __scrH * 0.9,
//                       color: Colors.black,
//                       child: _cameraController.value.isInitialized ? 
//                       CameraPreview(_cameraController) :
//                       CircularProgressIndicator(
//                         color: HexColor('#6ab547'),
//                       )
//                     ),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         color: Colors.transparent,
//                         height: _scrH * 0.3,
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(scrW * 0.065, _scrH * 0.04, scrW * 0.065, _scrH * 0.0),
//                                 child: SizedBox(
//                                   // decoration: BoxDecoration(
//                                   //   border: Border.all(color: Colors.black),
//                                   //   borderRadius: BorderRadius.circular(10.0)
//                                   // ),
//                                   // color: Colors.red,
//                                   height: _scrH * 0.15,
//                                   child: Row(
//                                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       SizedBox(
//                                         width: scrW * 0.65,
//                                         child: ListView.builder(
//                                           scrollDirection: Axis.horizontal,
//                                           shrinkWrap: true,
//                                           itemCount: capturedImages.length,
//                                           itemBuilder: (context, index) {
//                                             return Padding(
//                                               padding: const EdgeInsets.only(left: 5.0),
//                                               child: Container(
//                                                 height: 80,
//                                                 width: 60,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.transparent,
//                                                   // borderRadius: BorderRadius.circular(10),
//                                                   image: DecorationImage(
//                                                     image: FileImage(
//                                                       File(capturedImages[index].path),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }
//                                         ),
//                                       ),
//                                       const VerticalDivider(color: Colors.white,),
//                                       IconButton(icon: const Icon(Icons.add_photo_alternate_outlined), iconSize: _scrH * 0.075, color: Colors.white, //HexColor('#6ab547'),
//                                       onPressed: () async {
//                                         final pickedFile = await picker.pickImage(source: ImageSource.gallery).catchError((_) => null);
//                                         if (pickedFile != null) {
//                                           setState(() {
//                                             capturedImages.add(File(pickedFile.path));
//                                           });
//                                         }
//                                       },),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.white,
//                                 height: _scrH * 0.1,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: scrW * 0.02, vertical: _scrH * 0.005),
//                                       child: SizedBox(
//                                         width: scrW * 0.4,
//                                         child: Material(
//                                           elevation: 10.0,
//                                           shadowColor: Colors.white70.withOpacity(0.9),
//                                           color: Colors.transparent,
//                                           child: TextFormField(
//                                             controller: priceController,
//                                             style: const TextStyle(fontSize: 18.0),
//                                             decoration: const InputDecoration(
//                                               prefixIcon: Icon(Icons.attach_money, color: Colors.black38,),
//                                               hintText: 'Price',
//                                               hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey,),
//                                               fillColor: Colors.white,
//                                               filled: true,
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.all(Radius.circular(10.0),),
//                                                 borderSide: BorderSide(color: Colors.white, width: 3.0),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.all(Radius.circular(10.0),),
//                                                 borderSide: BorderSide(color: Colors.white, width: 3.0),
//                                               ),
//                                             ),
//                                             keyboardType: const TextInputType.numberWithOptions(),
//                                             textInputAction: TextInputAction.done,
//                                             validator: (val) => val!.isEmpty ? 'Please enter price' : null,
//                                             onChanged: (val) {
//                                               setState(() => price = val);
//                                             }
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     // TextButton.icon(
//                                     //   label: Text('Add More Info', style: TextStyle(fontSize: scrW * 0.045, color: Colors.black),),
//                                     //   icon: const Icon(Icons.add, size: 24.0, color: Colors.black),
//                                     //   onPressed: () async {
//                                     //     FocusScope.of(context).unfocus();
//                                     //     var res = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddInvInfo()));
//                                     //     // print (res.toString());
//                                     //     setState((){
//                                     //       brand = res[0];
//                                     //       type = res[1];
//                                     //       dimension = res[2];
//                                     //       color = res[3];
//                                     //       condition = res[4];
//                                     //     });
//                                     //   },
//                                     // ),
//                                     SizedBox(width: scrW * 0.05,),
//                                     Expanded(
//                                       child: ElevatedButton(
//                                         child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18.0),),
//                                         style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(30.0),
//                                           ),
//                                         ),
//                                         onPressed: () async {
//                                           FocusScope.of(context).unfocus();
//                                           if(capturedImages.isNotEmpty){
//                                             if(_formKey.currentState!.validate()){
//                                               syncImages = List.from(capturedImages);
//                                               syncPrice = price;
//                                               priceController.text = '';
//                                               capturedImages.clear();
//                                               // print('No. of images: ${syncImages.length}');
//                                               await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SuccessScreen()));
//                                               InvServices().addInventory(syncImages, syncPrice, brand, type, dimension, color, condition, compID);
//                                               // InvServices().addInventory(capturedImages, syncPrice, brand, type, dimension, color, condition, compID);
//                                               // AsyncService().asyncAddInventory(syncImages, syncPrice, brand, type, dimension, color, condition, compID);
//                                             }
//                                           } else {
//                                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add one or more product images and retry')));
//                                           }
//                                         }
//                                       ),
//                                     ),
//                                     SizedBox(width: scrW * 0.05,),
//                                   ],
//                                 )
//                               ),
//                             ]
//                           ),
//                         ),
//                       ),
//                     ),
//                     // TextButton.icon(
//                     //   label: const Text('Back', style: TextStyle(color: Colors.black,fontSize: 20.0)),
//                     //   icon: const Icon(Icons.arrow_back, color: Colors.black, size: 15.0),
//                     //   onPressed: (){
//                     //     Navigator.pop(context);
//                     //   }
//                     // ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           // child: IconButton(icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.clear, color: Colors.black,)), onPressed: (){Navigator.pop(context);},),
//                           child: ElevatedButton.icon(icon: const Icon(Icons.clear), label: const Text('BACK'), style: ElevatedButton.styleFrom(primary: Colors.white), onPressed: (){Navigator.pop(context);},),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.all(10.0),
//                         //   child: CircleAvatar(
//                         //     backgroundColor: Colors.white, 
//                         //     child: dtSync ? 
//                         //       AnimatedBuilder(
//                         //         animation: _animcontroller,
//                         //         builder: (_, child) {
//                         //           return Transform.rotate(
//                         //             angle: _animcontroller.value * 2 * math.pi,
//                         //             child: child,
//                         //           );
//                         //         },
//                         //         child: const Icon(Icons.autorenew, color: Colors.blue))
//                         //     : Icon(Icons.autorenew, color: Colors.grey.shade400)),
//                         // )
//                       ],
//                     ),
//                     Positioned(
//                       bottom: _scrH * 0.27,
//                       left: scrW * 0.43,
//                       child: InkWell(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black45, spreadRadius: 5)],
//                           ),
//                           child: CircleAvatar(
//                             radius: 30.0,
//                             backgroundColor: Colors.white,
//                             child: inProg ? const CircularProgressIndicator() : const Icon(Icons.camera_alt_outlined, size: 40.0, color: Colors.black54,),
//                           ),
//                         ),
//                         onTap: inProg ? () async {} :
//                         () async {
//                           if (_cameraController.value.isInitialized) {
//                             takePicture();
//                           }
//                         }
//                       ),
//                     ),
//                     // Positioned(
//                     //   bottom: 0.0,
//                     //   left: 0.0,
//                     //   right: 0.0,
//                     //   child: ElevatedButton(
//                     //     child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18.0),),
//                     //     style: ElevatedButton.styleFrom(
//                     //       shape: RoundedRectangleBorder(
//                     //         borderRadius: BorderRadius.circular(30.0),
//                     //       ),
//                     //     ),
//                     //     onPressed: () async {
//                     //       FocusScope.of(context).unfocus();
//                     //       if(capturedImages.isNotEmpty){
//                     //         if(_formKey.currentState!.validate()){
//                     //           syncImages = List.from(capturedImages);
//                     //           syncPrice = price;
//                     //           priceController.text = '';
//                     //           capturedImages.clear();
//                     //           // print('No. of images: ${syncImages.length}');
//                     //           await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SuccessScreen()));
//                     //           InvServices().addInventory(syncImages, syncPrice, brand, type, dimension, color, condition, compID);
//                     //         }
//                     //       } else {
//                     //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add one or more product images and retry')));
//                     //       }
//                     //     }
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//         //   );
//         // } else {
//         //   return const Loading();
//         // }
//       // }
//     );
//   }
// }
