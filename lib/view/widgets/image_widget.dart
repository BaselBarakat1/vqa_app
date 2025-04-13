import 'package:flutter/material.dart';

class imageWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12) ,topLeft:Radius.circular(12) ,bottomRight:Radius.circular(12) ,topRight:Radius.circular(0) ),
          ),
          child: Image.asset('assets/images/dog_image.png'),
        ),
      ],
    );
  }
}
