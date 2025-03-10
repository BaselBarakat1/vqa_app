import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(12),
             child: Row(
               children: [
                 Icon(Icons.history_outlined,size: 28,color: Colors.white,),
                 SizedBox(width: 11.5,),
                 Text('History',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),)
               ],
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(12),
             child: Row(
               children: [
                 Icon(Icons.settings_outlined,size: 28,color: Colors.white,),
                 SizedBox(width: 11.5,),
                 Text('Settings',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),)
               ],
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
                 child: Text('Username',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
               )
             ],
           )
         ],
        ),
      ),
    );
  }
}
