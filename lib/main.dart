import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refurbsy/auth/fire_auth.dart';
import 'package:refurbsy/widgets/global.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentUser(currUser: FirebaseAuth.instance.currentUser)),
        ChangeNotifierProvider(
          create: (_) => CompID(compID: '')),
      ],
    child: const MyApp()));
  // runApp(const MyApp());
}

void backgroundHandler() {
  WidgetsFlutterBinding.ensureInitialized();
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthService().handleAuth();
  }
}

Map<int, Color> color =
{
  50:const Color.fromRGBO(106, 181, 71, 1),
  100:const Color.fromRGBO(106, 181, 71, 2),
  200:const Color.fromRGBO(106, 181, 71, 3),
  300:const Color.fromRGBO(106, 181, 71, 4),
  400:const Color.fromRGBO(106, 181, 71, 5),
  500:const Color.fromRGBO(106, 181, 71, 6),
  600:const Color.fromRGBO(106, 181, 71, 7),
  700:const Color.fromRGBO(106, 181, 71, 8),
  800:const Color.fromRGBO(106, 181, 71, 9),
  900:const Color.fromRGBO(106, 181, 71, 0),
};