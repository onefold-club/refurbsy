import 'dart:io';
// import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:refurbsy/auth/fire_auth.dart';
import 'package:refurbsy/inventory/completedscreen.dart';
import 'package:refurbsy/inventory/galleryView.dart';
import 'package:refurbsy/inventory/imgprocessingscreen.dart';
import 'package:refurbsy/inventory/inventoryBloc/inventoryServices.dart';
import 'package:refurbsy/widgets/global.dart';
import 'package:refurbsy/widgets/spinner.dart';
import 'package:image/image.dart' as im;

class AddInv extends StatefulWidget {
  const AddInv({Key? key}) : super(key: key);

  @override
  _AddInvState createState() => _AddInvState();
}

// class _AddInvState extends State<AddInv> with SingleTickerProviderStateMixin {
class _AddInvState extends State<AddInv> {
  // late final AnimationController _animcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  List<CameraDescription> cameras = [];
  late CameraController _cameraController;
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<File> capturedImages = [];
  List<File> syncImages = [];
  late Rect rect;
  bool loading = true;
  bool inProg = false;
  bool imgProcessing = false;
  final picker = ImagePicker();

  String brand = '';
  String type = '';
  String dimension = '';
  String color = '';
  String condition = '';
  String price = '';
  String syncPrice = '';

  @override
  void initState() {
    getCameraControl();
    super.initState();
  }

  Future getCameraControl() async {
    await getCameras();
    await setController();
  }

  Future getCameras() async {
    cameras = await availableCameras();
  }

  Future setController() async {
    _cameraController = CameraController(cameras[0], ResolutionPreset.veryHigh);
    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
      });
    });
  }

  Future takePicture() async {
    setState(() {
      inProg = true;
    });
    if (_cameraController.value.isInitialized &&
        !_cameraController.value.isTakingPicture) {
      _cameraController.setFlashMode(FlashMode.off);
      XFile xFile = await _cameraController.takePicture();
      setState(() {
        capturedImages.add(File(xFile.path));
      });
      // await Future.delayed(const Duration(milliseconds: 500));
      // print('CACHE SIZE = ${imageCache!.currentSizeBytes}');
    }
    setState(() {
      inProg = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      getCameraControl();
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padH = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
    var scrW = _scrW - _padH;

    var compID = Provider.of<CompID>(context).compID;
    return loading
        ? const Loading()
        : imgProcessing
            ? const Processing()
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: _scrH,
                    child: Stack(
                      children: [
                        Container(
                            height: _scrH * 0.9,
                            color: Colors.black,
                            child: _cameraController.value.isInitialized
                                ? CameraPreview(_cameraController)
                                : CircularProgressIndicator(
                                    color: HexColor('#6ab547'),
                                  )),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            color: Colors.transparent,
                            height: _scrH * 0.3,
                            child: Form(
                              key: _formKey,
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(scrW * 0.065,
                                      _scrH * 0.04, scrW * 0.065, _scrH * 0.0),
                                  child: SizedBox(
                                    height: _scrH * 0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        capturedImages.isNotEmpty
                                            ? inProg
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : InkWell(
                                                    child: Container(
                                                        height: 80,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          // borderRadius: BorderRadius.circular(10),
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                              File(capturedImages[
                                                                      capturedImages
                                                                              .length -
                                                                          1]
                                                                  .path),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Center(
                                                            child: capturedImages
                                                                    .isNotEmpty
                                                                ? Text(
                                                                    capturedImages
                                                                        .length
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18.0),
                                                                  )
                                                                : const Text(
                                                                    ""))),
                                                    onTap: () {
                                                      List<String> imgList = [];
                                                      for (var img
                                                          in capturedImages) {
                                                        imgList.add(img.path);
                                                      }
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ImgGallery(
                                                                      imgList:
                                                                          imgList)));
                                                    })
                                            : const SizedBox(
                                                height: 80,
                                                width: 60,
                                              ),
                                        GestureDetector(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 10,
                                                      color: Colors.black45,
                                                      spreadRadius: 5)
                                                ],
                                              ),
                                              child: CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.white,
                                                child: inProg
                                                    ? const CircularProgressIndicator()
                                                    : const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 40.0,
                                                        color: Colors.black54,
                                                      ),
                                              ),
                                            ),
                                            onTap: inProg
                                                ? () async {}
                                                : () async {
                                                    if (_cameraController
                                                        .value.isInitialized) {
                                                      takePicture();
                                                    }
                                                  }),
                                        IconButton(
                                          icon: const Icon(Icons
                                              .add_photo_alternate_outlined),
                                          iconSize: _scrH * 0.075,
                                          color: Colors
                                              .white, //HexColor('#6ab547'),
                                          onPressed: () async {
                                            // final pickedFile = await picker.pickImage(source: ImageSource.gallery).catchError((_) => null);
                                            // if (pickedFile != null) {
                                            //   setState(() {
                                            //     capturedImages.add(File(pickedFile.path));
                                            //   });
                                            // }
                                            final List<XFile>? gallimgs =
                                                await picker.pickMultiImage();
                                            if (gallimgs!.isNotEmpty) {
                                              for (var file in gallimgs) {
                                                capturedImages
                                                    .add(File(file.path));
                                              }
                                              setState(() {
                                                _cameraController.dispose();
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    color: Colors.white,
                                    height: _scrH * 0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: scrW * 0.02,
                                              vertical: _scrH * 0.005),
                                          child: SizedBox(
                                            width: scrW * 0.4,
                                            child: Material(
                                              elevation: 10.0,
                                              shadowColor: Colors.white70
                                                  .withOpacity(0.9),
                                              color: Colors.transparent,
                                              child: TextFormField(
                                                  controller: priceController,
                                                  style: const TextStyle(
                                                      fontSize: 18.0),
                                                  decoration:
                                                      const InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.attach_money,
                                                      color: Colors.black38,
                                                    ),
                                                    hintText: 'Price',
                                                    hintStyle: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.grey,
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(),
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  validator: (val) =>
                                                      val!.isEmpty
                                                          ? 'Please enter price'
                                                          : null,
                                                  onChanged: (val) {
                                                    setState(() => price = val);
                                                  }),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: scrW * 0.05,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (capturedImages.isNotEmpty) {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    syncImages = List.from(
                                                        capturedImages);
                                                    syncPrice = price;
                                                    priceController.text = '';
                                                    capturedImages.clear();
                                                    setState(() {
                                                      imgProcessing = true;
                                                    });
                                                    List<String> imgUrls = [];
                                                    final dir = Platform
                                                            .isAndroid
                                                        ? await getExternalStorageDirectory()
                                                        : await getApplicationSupportDirectory();
                                                    final imageFldr =
                                                        '${dir!.path}/Inventory_Img';

                                                    if (await Directory(
                                                                imageFldr)
                                                            .exists() !=
                                                        true) {
                                                      await Directory(imageFldr)
                                                          .create();
                                                    }
                                                    for (File img
                                                        in syncImages) {
                                                      Map map = {};
                                                      map['img'] = img;
                                                      map['dir'] = imageFldr;

                                                      var path = await compute(
                                                          processImg, map);
                                                      imgUrls.add(path);
                                                    }
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                const SuccessScreen()));
                                                    imageCache!.clear();
                                                    setState(() {
                                                      imgProcessing = false;
                                                    });
                                                    InvServices().addInventory(
                                                        imgUrls,
                                                        syncImages,
                                                        syncPrice,
                                                        brand,
                                                        type,
                                                        dimension,
                                                        color,
                                                        condition,
                                                        compID);
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Add one or more product images and retry')));
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          width: scrW * 0.05,
                                        ),
                                      ],
                                    )),
                              ]),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.clear),
                                  label: const Text('BACK'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}

Future processImg(Map map) async {
  var imageFldr = map['dir'];
  var img = map['img'];

  im.Image? image = im.decodeImage((img).readAsBytesSync());
  var newImgFile = File("$imageFldr/image_${DateTime.now()}.jpg")
    ..writeAsBytesSync(im.encodeJpg(image!, quality: 100));
  return newImgFile.path;
}
