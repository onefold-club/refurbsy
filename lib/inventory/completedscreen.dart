import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: FlareActor("assets/img/check.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Untitled", callback: (_) {
                // Navigator.pop(context);
                Navigator.pop(context);
              }),
            ),
            const Text(
              "Inventory added successfully!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
