import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';

class splashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, loginScreen.routeName);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/splash_screen_background.png'),
        fit: BoxFit.fill
        )
      ) ,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/logo.png')),
            //Text('Visual Question Answering',style: TextStyle(color: Colors.white,fontSize:24 ,fontWeight:FontWeight.w400 ),)
          ],
        ),
      ),
    );
  }
}
