
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:refurbsy/auth/fire_auth.dart';
import 'package:refurbsy/inventory/addinv.dart';
import 'package:refurbsy/inventory/availableInv.dart';
import 'package:refurbsy/inventory/soldinv.dart';
import 'package:refurbsy/widgets/spinner.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({ Key? key }) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

// class _InventoryPageState extends State<InventoryPage> with SingleTickerProviderStateMixin {
class _InventoryPageState extends State<InventoryPage>{

  // late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  late QuerySnapshot allInv;
  late QuerySnapshot soldInv;
  bool loading = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // var _scrH = MediaQuery.of(context).size.height;
    // var _scrW = MediaQuery.of(context).size.width;
    // var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    // var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    // var scrH = _scrH - _padV - kToolbarHeight;
    // var scrW = _scrW - _padH;

    // return StreamBuilder<DataSync>(
    //     stream: AuthService().syncStatus,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         DataSync? syncData = snapshot.data;
    //         var dtSync = syncData!.isSync;
            return DefaultTabController(
              length: 2, // Praveen: should be 3 for 'Request' tab which is not enabled for now
              child: loading ? const Loading() : Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                elevation: 0.0,
                title: const Text('Inventory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),),
                centerTitle: true,
                actions: [
                  IconButton(icon: const Icon(Icons.logout_sharp, color: Colors.white,), onPressed: (){ AuthService().signOut(); }),],
                  // dtSync ? 
                  //   Padding(
                  //     padding: const EdgeInsets.all(15.0),
                  //     child: AnimatedBuilder(
                  //       animation: _controller,
                  //       builder: (_, child) {
                  //         return Transform.rotate(
                  //           angle: _controller.value * 2 * math.pi,
                  //           child: child,
                  //         );
                  //       },
                  //       child: const Icon(Icons.autorenew, color: Colors.blue)),
                  //   ) :
                  //     Padding(
                  //       padding: const EdgeInsets.all(15.0),
                  //       child: Icon(Icons.autorenew, color: Colors.grey.shade400),
                  //     ),
                // ],
                bottom: TabBar(
                  indicatorColor: HexColor('#ffffff').withOpacity(0.5),
                  indicatorWeight: 4.0,
                  labelColor: HexColor('#ffffff'),
                  labelStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  tabs:const [
                    Tab(child: Text('All'),),
                    Tab(child: Text('Sold'),),
                  ]
                ),
              ),
              body: const TabBarView(
                children: [
                  AllInvList(),
                  SoldInvList(),
                ],
              ),
              
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.control_point, color: Colors.white),
                label: const Text('ADD INVENTORY', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddInv()));
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  
                ),
      //       );
      //     } else {
      //       return const Loading();
      //     }
      // }
    );
  }
  //   Future<bool> _syncOn() async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Images Sync is in progress'),
  //       content: const Text('Terminate Image upload and close app?'),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: (){ Navigator.pop(context); },
  //           child: const Text('No'),
  //         ),
  //         ElevatedButton(
  //           onPressed: (){ 
  //             Navigator.pop(context);
  //             SystemChannels.platform.invokeMethod('SystemNavigator.pop');},
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   ));
  // }
  // Future<bool> _syncOff() async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Exit App?'),
  //       // content: const Text('Exit the app?'),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: (){ Navigator.pop(context); },
  //           child: const Text('No'),
  //         ),
  //         ElevatedButton(
  //           onPressed: (){ 
  //             Navigator.pop(context); 
  //             SystemChannels.platform.invokeMethod('SystemNavigator.pop');},
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   ));
  // }

}