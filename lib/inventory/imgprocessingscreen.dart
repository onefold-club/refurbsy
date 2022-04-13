import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Processing extends StatelessWidget {
  const Processing({Key? key}) : super(key: key);
  final int tabIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/img/loading.json'),
              const SizedBox(height: 30.0,),
              const Text('Processing your images ...', style: TextStyle(fontSize: 20.0, color: Colors.green, fontWeight: FontWeight.bold),)
            ],
          ),
        )
      ),
    );
  }
}