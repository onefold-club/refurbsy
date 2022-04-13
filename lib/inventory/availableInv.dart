import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:refurbsy/inventory/inventoryBloc/inventoryServices.dart';
import 'package:refurbsy/inventory/webgallery.dart';

import '../widgets/spinner.dart';

class AllInvList extends StatelessWidget {
  const AllInvList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    var scrH = _scrH - _padV - kToolbarHeight;
    var scrW = _scrW - _padH;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inventory').where('status', isEqualTo: 'Available').orderBy('createdDt', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if( !snapshot.hasData ){ return const Loading(); }
        else if( snapshot.data!.docs.isEmpty) { return const Center(child: Text('No items found!')); }
        return SizedBox(
          height: _scrH * 0.85,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            children:snapshot.data!.docs.map(
              (DocumentSnapshot doc) {
                List images = (doc.data() as dynamic)['images'];
                List<String> imgStr = List<String>.from(images);
                int totImgCount = (doc.data() as dynamic)['imagesCount'];
                var thumbnail = (doc.data() as dynamic)['thumbUrl'];
                bool isSynced = (doc.data() as dynamic)['isSynced'];
                // var uploaded = (doc.data() as dynamic)['uploaded'];
                String status = (doc.data() as dynamic)['status'].toString().toUpperCase();
                return SizedBox(
                  height: scrH * 0.175,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: scrH * 0.005),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: scrH * 0.005, horizontal: scrW * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    InkWell(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                        child: CachedNetworkImage(
                                          imageUrl: thumbnail,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          fit: BoxFit.fill,
                                          // width: 65,
                                        ),
                                      ),
                                      onTap: isSynced ? () async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ImgGallery_Web(imgList: imgStr)));
                                      }
                                      : () async {},
                                    ),
                                    // isSynced ? const SizedBox() : const Positioned(bottom: 45.0, left: 10.0, child: CupertinoActivityIndicator(color: Colors.white, radius: 18.0,)),
                                    isSynced ? const SizedBox() : const Positioned(bottom: 35.0, left: 15.0, child: CupertinoActivityIndicator(color: Colors.white,)),
                                    Container(
                                      // color: Colors.white,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(images.length.toString().padLeft(2, '0'), style: const TextStyle(color: Colors.black)),
                                          const Text('/', style: TextStyle(color: Colors.black)),
                                          Text(totImgCount.toString().padLeft(2, '0'), style: const TextStyle(color: Colors.black)),
                                        ]
                                    ))
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('\$ ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('${(doc.data() as dynamic)['price']}', style: const TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              width: scrW * 0.3,
                              height: scrH * 0.04,
                              child: ElevatedButton.icon(
                                label: Text(status, style: TextStyle(color: status == 'AVAILABLE' ? Colors.green : Colors.yellow.shade700, fontSize: scrW * 0.03)),
                                icon: CircleAvatar(
                                  backgroundColor: status == 'AVAILABLE' ? Colors.green : Colors.yellow.shade700,
                                  radius: 8.0),
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                                onPressed: () async {
                                  // if(status == 'AVAILABLE') {
                                    await InvServices().updateStatusSold(doc.id);
                                  // }
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                );
              }
            ).toList(),
          ),
        );
      }
    );
  }
}