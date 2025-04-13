import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vqa_app/view/home/home_drawer.dart';
import 'package:vqa_app/view/widgets/image_widget.dart';
import 'package:vqa_app/view/widgets/question_text_field.dart';
import 'package:vqa_app/view/widgets/question_widget.dart';

class homeScreen extends StatefulWidget {
static const String routeName = 'Home_Screen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
File? file;
TextEditingController questionController = TextEditingController();
int index =0;

getImage() async {
  final ImagePicker picker = ImagePicker();
// Pick an image.
 final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
 // final XFile? photoCamera = await picker.pickImage(source: ImageSource.camera);
  file = File(image!.path);
  setState(() {});
}

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
             //crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 24),
                 child: Column(
                   children: [
                     if(index == 1 ) Padding(
                       padding: const EdgeInsets.symmetric(vertical: 8),
                       child: questionWidget(Question: questionController.text,),
                     ),
                     if(file != null) ClipRRect(
                         borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12) ,topLeft:Radius.circular(12) ,bottomRight:Radius.circular(12) ,topRight:Radius.circular(0) ),
                         child: Image.file(file!,)),

                   ],
                 ),
               ),
               Spacer(),
               TextFormField(
                 controller: questionController,
                 maxLines: 3,
                 minLines: 1,
                 textAlign: TextAlign.start,
                 cursorColor: Colors.white,
                 style: TextStyle(color: Colors.white),
                 decoration: InputDecoration(
                   fillColor: Color(0xff18222E),
                   filled: true,
                   prefixIcon:Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 12),
                     child: IconButton(onPressed: () {
                        getImage();
                     }, icon: Icon(Icons.add_photo_alternate_outlined)),
                   ),
                   prefixIconColor: Colors.white,
                   suffixIcon: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 12),
                     child: IconButton(onPressed: () {
                       send();
                     }, icon: Icon(Icons.send)),
                   ),
                   suffixIconColor: Colors.white,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(28),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(28),
                     borderSide: BorderSide(style: BorderStyle.none),
                   ),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(28),
                     borderSide: BorderSide(style: BorderStyle.none),
                   ),
                   hintText: 'Enter your Question',
                   hintStyle: TextStyle(fontSize: 18,fontWeight:FontWeight.w400 ,color: Colors.white,),
                   floatingLabelBehavior: FloatingLabelBehavior.never,
                 ),
               )
               //QuestionTextField(controller: questionController,maxLines: 3,onSendButtonClicked: send,)
             ],
           ),
         ),
       ),
     ),
    );
  }
  void send(){
  index =1;
  setState(() {

  });
  }
}

