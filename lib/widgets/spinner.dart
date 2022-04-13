import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final int tabIndex = 1;

  const Loading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: CircularProgressIndicator(
            color: HexColor('#6ab547'),
          ),
        ),
      ),
    );
  }
}