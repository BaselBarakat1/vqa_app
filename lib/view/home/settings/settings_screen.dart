import 'package:flutter/material.dart';
import 'package:vqa_app/view/home/home_screen.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';

class settings_screen extends StatefulWidget{
static const String routeName = 'Settings_Screen';

  @override
  State<settings_screen> createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen> {
bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/home_screen_background.png'),
            fit: BoxFit.fill
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings',style: TextStyle(fontWeight:FontWeight.w400,fontSize:22 ,color: Colors.white)),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 65),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.dark_mode_outlined,color: Colors.white,size: 32),
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Change Theme',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)),
                  Spacer(),
                  Switch(
                      activeTrackColor: Color(0xff16305C),
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                  )
                ],
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {

                },
                child: Row(
                  children: [
                    Icon(Icons.help_outline,color: Colors.white,size: 32),
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Help',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              InkWell(
                onTap: () {
                 Navigator.pushReplacementNamed(context, loginScreen.routeName);//Edit
                },
                child: Row(
                  children: [
                    Icon(Icons.logout,color: Colors.white,size: 32),
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Sign out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
