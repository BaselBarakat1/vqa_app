import 'package:flutter/material.dart';
typedef OnSendButtonClicked = void Function();
class QuestionTextField extends StatelessWidget {
  int? maxLines;
  TextEditingController? controller;
  OnSendButtonClicked onSendButtonClicked;

  QuestionTextField({ this.controller , this.maxLines,required this.onSendButtonClicked,});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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

          }, icon: Icon(Icons.add_photo_alternate_outlined)),
        ),
        prefixIconColor: Colors.white,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(onPressed: () {
            onSendButtonClicked();
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
    );
  }
}
