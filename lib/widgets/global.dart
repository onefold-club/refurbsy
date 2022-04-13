import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser with ChangeNotifier {
  CurrentUser({required this.currUser});

  User? currUser;
  
  changeUser(User? newUser) {
    currUser = newUser;
    notifyListeners();
    // printNewSelection();
  }
}

class CompID with ChangeNotifier {
  CompID({required this.compID});

  String compID;
  
  changeCompID(String newCompID) {
    compID = newCompID;
    notifyListeners();
    // printNewSelection();
  }
}

// class DataSync with ChangeNotifier {
//   DataSync({required this.dataSync});

//   bool dataSync;
  
//   syncStatus(bool isSync) {
//     dataSync = isSync;
//     notifyListeners();
//     // printNewSelection();
//   }
// }