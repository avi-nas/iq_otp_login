import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iq_otp_login/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


import '../reusablec_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _numberTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _otpTextController = TextEditingController();
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                resuableTextField("Phone Number",Icons.verified_user,false,_numberTextController),
                const SizedBox(
                  height: 30,
                ),

                signInSignUpButton(context, false, () async {
                  Fluttertoast.showToast(
                    msg: "Wait For verification",
                      toastLength: Toast.LENGTH_LONG,
                  );
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+91${_numberTextController.text.trim()}" ,
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      print(verificationId);
                      _verificationId = verificationId;

                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    timeout: const Duration(seconds: 60)
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                  child: Container(
                    alignment: Alignment.topLeft,

                    child: const Text('Enter OTP',
                      style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 3.0),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: Colors.white60,
                      inactiveFillColor: Colors.transparent,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,

                    controller: _otpTextController,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    }, appContext: context,
                  ),
                ),


                const SizedBox(
                  height: 5,
                ),
                signInSignUpButton(context, true, () async {
                   FirebaseAuth auth = FirebaseAuth.instance;
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider
                            .credential(verificationId: _verificationId,
                            smsCode: _otpTextController.text.trim());
                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                        });

                      }catch(e){
                        if (kDebugMode) {
                          print("Wrong OTP");
                        }
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




