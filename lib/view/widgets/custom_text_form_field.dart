import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);
class customTextFormField extends StatelessWidget {
  Icon? prefixIcon;
  Widget? suffixIcon;
  String labelText ;
  bool obsecureText ;
  Validator? validator;
  int? maxLines;
  TextEditingController? controller;
  customTextFormField({required this.labelText,this.validator,this.controller,this.prefixIcon,this.obsecureText = false,this.suffixIcon,this.maxLines});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: obsecureText,
        controller: controller ,
        validator: validator,
        maxLines: maxLines,
        minLines: maxLines,
        cursorColor: Color(0xff2C2C2C),
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            suffixIcon: suffixIcon ,
            suffixIconColor:Color(0xff0B182D) ,
            prefixIcon: prefixIcon,
            prefixIconColor: Color(0xff0B182D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xff2C2C2C),width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(0xffB3B3B3),
                  width: 1,
                )
            ),
            //label: Text(labelText),
            hintText: labelText,
            //labelStyle: TextStyle(color:Color(0xffB3B3B3) ,fontSize: 16,fontWeight: FontWeight.w500),
            //floatingLabelStyle: TextStyle(color: Color(0xff2C2C2C))

        ),
      ),
    );
  }
}
