import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:gallery_view/gallery_view.dart';

class ImgGallery extends StatelessWidget {
  const ImgGallery({ Key? key, required this.imgList }) : super(key: key);
  final List<String> imgList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(elevation: 0.0, backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white),),
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _buildPage(imgList[index]);
        },
        itemCount: imgList.length,
      )
    );
  }
  _buildPage(imgPath){
    return Container(
      child: PhotoView(
        imageProvider: AssetImage(imgPath),
      )
    );
  }
}