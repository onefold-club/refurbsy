import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refurbsy/auth/login.dart';
import 'package:refurbsy/auth/userModel.dart';
import 'package:refurbsy/main.dart';
import 'package:refurbsy/widgets/spinner.dart';
import 'package:refurbsy/widgets/wrapper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // User? user = FirebaseAuth.instance.currentUser;

  handleAuth() {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active
        || snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: MaterialColor(0xff6ab547, color),
                fontFamily: 'Roboto',
              ),
              home: const Wrapper());
          } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: MaterialColor(0xff6ab547, color),
              fontFamily: 'Roboto',
            ),
            home: const LoginPage());
          }
        } else { return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff6ab547, color),
          fontFamily: 'Roboto',
        ),
        home: const Loading()); }
      });
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  Future anonymousSignIn() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future emailPwdSingIn(email, password) async {
    try{  
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } catch(e){
      return e.toString();
    }
  }

  Future resetpwd(email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'Success';
    } catch(e){
      return e.toString();
    }
  }

    Stream<DataSync> get syncStatus {
      User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots()
      .map(_expUserObjListFromSnapshot);
    }
    DataSync _expUserObjListFromSnapshot(DocumentSnapshot snapshot) {
      return DataSync(
        isSync: (snapshot.data() as dynamic)['isSync'],
      );
    }
}

class DataSync {
  bool isSync;
  DataSync({ required this.isSync });
}
