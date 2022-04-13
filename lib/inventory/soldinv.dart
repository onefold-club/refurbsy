import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refurbsy/widgets/spinner.dart';

class SoldInvList extends StatelessWidget {
  const SoldInvList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    var scrH = _scrH - _padV - kToolbarHeight;
    var scrW = _scrW - _padH;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inventory').where('status', isEqualTo: 'Sold').orderBy('createdDt', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if( !snapshot.hasData ){ return const Loading(); }
        else if( snapshot.data!.docs.isEmpty) { return const Center(child: Text('No items added!')); }
        return SizedBox(
          height: _scrH * 0.85,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            children:snapshot.data!.docs.map(
              (DocumentSnapshot doc) {
                List images = (doc.data() as dynamic)['images'];
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
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              child: CachedNetworkImage(
                                imageUrl: images[0],
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.fill,
                                // width: 65,
                              ),
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
                                label: Text(status, style: TextStyle(color: status == 'AVAILABLE' ? Colors.green : Colors.yellow.shade700)),
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
                                onPressed: () async {}
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