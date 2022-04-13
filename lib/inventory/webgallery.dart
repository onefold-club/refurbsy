import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:gallery_view/gallery_view.dart';

class ImgGallery_Web extends StatelessWidget {
  const ImgGallery_Web({ Key? key, required this.imgList }) : super(key: key);
  final List<String> imgList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(elevation: 0.0, backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white),),
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) {
              return _buildPage(imgList[index]);
            },
            itemCount: imgList.length,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40.0), 
            child: InkWell(
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.clear, color: Colors.black,),
              ),
              onTap: (){ Navigator.pop(context); }
            ),
          ),
        ],
      )
    );
  }
  _buildPage(imgPath){
    return Container(
      width: double.infinity,
      height: double.infinity,
      // decoration: BoxDecoration(
        // image: DecorationImage(
          child:FadeInImage.assetNetwork(
            placeholder: 'assets/img/loading.gif',
            image: imgPath,
        // ),
      ),
    );
  }
}