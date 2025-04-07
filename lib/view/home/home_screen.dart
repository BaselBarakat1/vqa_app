import 'package:flutter/material.dart';
import 'package:vqa_app/view/home/home_drawer.dart';
import 'package:vqa_app/view/widgets/question_text_field.dart';

class homeScreen extends StatelessWidget {
static const String routeName = 'Home_Screen';
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/home_screen_background.png'),
            fit: BoxFit.fill
        ),
      ),
     child: Scaffold(
      appBar: AppBar(
        title: Text('VQA',style: TextStyle(fontWeight:FontWeight.bold,fontSize:24 ,color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.menu_outlined,color: Colors.white,size: 24),
            onPressed: () {
              if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                _scaffoldKey.currentState?.openDrawer();
              } else {
                _scaffoldKey.currentState?.openEndDrawer();
              }
            }),
      ),
       body: Scaffold(
         key: _scaffoldKey,
         drawer:HomeDrawer(),
         body: Container(
           padding: EdgeInsets.all(14),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Container(
                 padding: EdgeInsets.only(bottom: 182),
                 child: Column(
                   children: [
                     Padding(
                       padding: EdgeInsets.symmetric(vertical: 35),
                       child: Text('Wondering\nabout an Image?',textAlign: TextAlign.center,style: TextStyle(
                         color: Colors.white,
                         fontSize: 40,
                         fontWeight:FontWeight.w400,
                       )),
                     ),
                     Text("I'm here to help!",textAlign: TextAlign.center,style: TextStyle(
                       color: Colors.white,
                       fontSize: 40,
                       fontWeight:FontWeight.w400,
                     )),
                   ],
                 ),
               ),
               Container(
                   child: questionTextField()),
             ],
           ),
         ),
       ),
     ),
    );
  }
}
