import 'package:flutter/material.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';
import 'package:vqa_app/view/home/register/register_screen.dart';
import 'package:vqa_app/view/splash/splash_screen.dart';
import 'package:vqa_app/view/styles/my_theme_data.dart';

void main(){
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     routes: {
      splashScreen.routeName : (context) => splashScreen(),
      loginScreen.routeName : (context) => loginScreen(),
      registerScreen.routeName : (context) => registerScreen(),
     },
     initialRoute: splashScreen.routeName ,
     theme: MyThemeData.lightTheme,
   );
  }

}