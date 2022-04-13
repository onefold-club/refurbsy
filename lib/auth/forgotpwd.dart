import 'package:flutter/material.dart';
import 'package:refurbsy/auth/fire_auth.dart';

class FrgtPwd extends StatefulWidget {
  const FrgtPwd({ Key? key }) : super(key: key);

  @override
  _FrgtPwdState createState() => _FrgtPwdState();
}

class _FrgtPwdState extends State<FrgtPwd> {

  final _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {

    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    var scrH = _scrH - _padV - kToolbarHeight;
    var scrW = _scrW - _padH;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: scrH * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Please enter email id', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: scrH * 0.025,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: scrW * 0.05, vertical: scrH * 0.015),
                    child: Material(
                      elevation: 10.0,
                      shadowColor: Colors.white70.withOpacity(0.9),
                      color: Colors.transparent,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.black38,),
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            borderSide: BorderSide(color: Colors.white, width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            borderSide: BorderSide(color: Colors.white, width: 3.0)
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ? 'Please provide a valid email id to login' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: scrH * 0.025),
                    child: Container(
                      width: scrW * 0.9,
                      height: scrH * 0.07,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                      child: ElevatedButton(
                        child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            var res = await AuthService().resetpwd(email);
                            if (res == 'Success'){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check your inbox for password reset instructions')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Please verify email retry')));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}