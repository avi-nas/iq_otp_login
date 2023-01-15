import 'package:fluttertoast/fluttertoast.dart';
import 'package:iq_otp_login/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import '../reusablec_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _numberTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _otpTextController = TextEditingController();
  late String _verificationCode;
  late String _verificationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:const Text('Sign Up'),
      ),
      body:  Container(
      width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Colors.pink,
    Colors.blue,
    Colors.lightBlue
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
    )),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                resuableTextField("Phone Number",Icons.verified_user,false,_numberTextController),
                SizedBox(
                  height: 30,
                ),

                signInSignUpButton(context, false, () async {
                  Fluttertoast.showToast(
                    msg: "Wait For verification",
                      toastLength: Toast.LENGTH_LONG,
                  );
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: _numberTextController.text.trim() ,
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      print(verificationId);
                      _verificationId = verificationId;

                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    timeout: Duration(seconds: 60)
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                resuableTextField("OTP",Icons.lock,false,_otpTextController),
                SizedBox(
                  height: 30,
                ),
                signInSignUpButton(context, false, () async {
                   FirebaseAuth auth = FirebaseAuth.instance;
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider
                            .credential(verificationId: _verificationId,
                            smsCode: _otpTextController.text.trim());
                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        });

                      }catch(e){
                        print("Wrong OTP");
                        Fluttertoast.showToast(
                          msg: "Wrong OTP",
                          toastLength: Toast.LENGTH_LONG,
                        );

                      }
                      },
                ),

              ],
            ),
          ),
        ),
    ));
  }
}




