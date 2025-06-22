import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/view/home/history/history_screen.dart';
import 'package:vqa_app/view/home/settings/settings_screen.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<MyAuthProvider>(context);
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
         children: [
           InkWell(
             onTap: () {
               Navigator.pushNamed(context, historyScreen.routeName);
             },
             child: Padding(
               padding: const EdgeInsets.all(12),
               child: Row(
                 children: [
                   Icon(Icons.history_outlined,size: 28,color: Colors.white,),
                   SizedBox(width: 11.5,),
                   Text('History',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),)
                 ],
               ),
             ),
           ),
           InkWell(
             onTap: () {
               Navigator.pushNamed(context, settings_screen.routeName);
             },
             child: Padding(
               padding: const EdgeInsets.all(12),
               child: Row(
                 children: [
                   Icon(Icons.settings_outlined,size: 28,color: Colors.white,),
                   SizedBox(width: 11.5,),
                   Text('Settings',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),)
                 ],
               ),
             ),
           ),
           Container(
             padding: EdgeInsets.symmetric(horizontal: 12),
               child: Divider(color: Color(0xffCAC4D0),thickness: 1.8)
           ),
           Spacer(),
           Row(
             children: [
               Image.asset('assets/images/username_icon.png'),
               Padding(
                 padding:EdgeInsets.only(left: 14),
                 child: Text(authProvider.databaseUser!.userName!,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
               )
             ],
           )
         ],
        ),
      ),
    );
  }
}
