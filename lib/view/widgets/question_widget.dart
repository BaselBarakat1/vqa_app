import 'package:flutter/material.dart';

class questionWidget extends StatelessWidget {
String Question;
questionWidget({required this.Question});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xff18222E),
            border: Border.all(
                color: Colors.white,
                width: 0.7
            ),
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12) ,topLeft:Radius.circular(12) ,bottomRight:Radius.circular(12) ,topRight:Radius.circular(0) ),
          ),
          child: Text(Question,style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400 ,fontSize: 18)),
        ),
      ],
    );
  }
}
