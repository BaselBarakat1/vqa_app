import 'package:flutter/material.dart';

class searchItemTextField extends StatelessWidget {
  TextEditingController? controller;
  final Function(String)? onChanged; // Add this parameter

  searchItemTextField({this.controller, this.onChanged}); // Add onChanged to constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 18),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged, // Add this line
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              // Optional: Clear search when search icon is pressed
              if (controller != null) {
                controller!.clear();
                if (onChanged != null) {
                  onChanged!(''); // Notify parent that search is cleared
                }
              }
            },
            icon: Icon(Icons.search),
          ),
          suffixIconColor: Colors.white,
          filled: true,
          fillColor: Color(0xff18222E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none, // Remove border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none, // Remove border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none, // Remove border
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}