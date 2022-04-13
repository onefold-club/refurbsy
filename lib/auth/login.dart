import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:refurbsy/auth/fire_auth.dart';
import 'package:refurbsy/auth/forgotpwd.dart';
import 'package:refurbsy/widgets/spinner.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool remChk = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pwd = '';

  @override
  Widget build(BuildContext context) {

    var _scrH = MediaQuery.of(context).size.height;
    var _scrW = MediaQuery.of(context).size.width;
    var _padV = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
    var _padH = MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right;

    var scrH = _scrH - _padV - kToolbarHeight;
    var scrW = _scrW - _padH;

    return loading ? const Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: scrH * 0.23, bottom: scrH * 0.1),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Text('Sign In', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
              //   ],
              // ),
              child: Container(
                height: 60.0,
                width: 300.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/img/Refurbsy.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
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
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty ? 'Please provide a valid email id to login' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: scrW * 0.05, vertical: scrH * 0.015),
                    child: Material(
                      elevation: 10.0,
                      shadowColor: Colors.white70.withOpacity(0.9),
                      color: Colors.transparent,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.black38,),
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey,),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            borderSide: BorderSide(color: Colors.white, width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            borderSide: BorderSide(color: Colors.white, width: 3.0),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        validator: (val) => val!.isEmpty ? 'Please enter password' : null,
                        onChanged: (val) {
                          setState(() => pwd = val);
                        }
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: scrW * 0.04),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(child: const Text('Forgot Password ?'), onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FrgtPwd()));
                        },)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: scrW * 0.04),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          side: const BorderSide(
                            color: Colors.black54,),
                          value: remChk, onChanged: (val) {
                          setState(() {
                            remChk = val!;
                          });
                        }),
                        const Text('Remember Me', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey,)),
                      ],
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
                        child: const Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            setState(() { loading = true; });
                            var res = await AuthService().emailPwdSingIn(email, pwd);
                            if (res == 'Success'){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have successfully signed in')));
                              setState((){ loading = false; });
                            } else {
                              setState((){ loading = false; });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Please verify email & password and retry')));
                              // print(res);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: scrH * 0.035, horizontal: scrW * 0.04),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Expanded(
            //         child: Divider(
            //                 indent: 20.0,
            //                 endIndent: 10.0,
            //                 thickness: 1,
            //               ),
            //       ),
            //       Text(
            //           "OR",
            //           style: TextStyle(color: Colors.blueGrey),
            //       ),
            //       Expanded(
            //           child: Divider(
            //                   indent: 10.0,
            //                   endIndent: 20.0,
            //                   thickness: 1,
            //           ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: scrH * 0.035, horizontal: scrW * 0.04),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Container(
            //         width: scrW * 0.4,
            //         height: scrH * 0.07,
            //         decoration: const BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(50.0))
            //         ),
            //         child: ElevatedButton(
            //           child: const Text('Facebook', style: TextStyle(color: Colors.white, fontSize: 16.0),),
            //           style: ElevatedButton.styleFrom(
            //             primary: HexColor('#475a96'),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(30.0),
            //             ),
            //           ),
            //           onPressed: (){},
            //         ),
            //       ),
            //       Container(
            //         width: scrW * 0.4,
            //         height: scrH * 0.07,
            //         decoration: const BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(50.0))
            //         ),
            //         child: ElevatedButton(
            //           child: const Text('Google', style: TextStyle(color: Colors.white, fontSize: 16.0),),
            //           style: ElevatedButton.styleFrom(
            //             primary: HexColor('#dd4b39'),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(30.0),
            //             ),
            //           ),
            //           onPressed: (){},
            //         ),
            //       ),
            //     ]
            //   ),
            // ),
          ],
        )
      )
    );
  }
}