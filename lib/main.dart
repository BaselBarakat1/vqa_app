import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/firebase_options.dart';
import 'package:vqa_app/view/home/history/history_screen.dart';
import 'package:vqa_app/view/home/home_screen.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';
import 'package:vqa_app/view/home/register/register_screen.dart';
import 'package:vqa_app/view/home/settings/settings_screen.dart';
import 'package:vqa_app/view/splash/splash_screen.dart';
import 'package:vqa_app/view/styles/my_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => MyAuthProvider(),
      child: MyApplication()));
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
       HomeScreen.routeName : (context) => HomeScreen(),
       settings_screen.routeName : (context) => settings_screen(),
       historyScreen.routeName : (context) => historyScreen(),
     },
     initialRoute: splashScreen.routeName ,
     theme: MyThemeData.lightTheme,
   );
  }

}