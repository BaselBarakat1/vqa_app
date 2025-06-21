import 'package:flutter/material.dart';

class searchItemTextField extends StatelessWidget {
  TextEditingController? controller;

   searchItemTextField({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8,bottom: 18),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: () {
            
          }, icon: Icon(Icons.search)),
          suffixIconColor: Colors.white,
          filled: true,
          fillColor: Color(0xff18222E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          hintText:'Search',
          hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),

      ),
    );
  }
}
