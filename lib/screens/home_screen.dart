
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iq_otp_login/screens/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.blue,
                  Colors.lightBlue
                ],

          ),
          ),
        child:  Center(
          child: ElevatedButton(
            child: Text('LogOut'),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
            },
          ),
        ),
        ),
      );

  }
}
