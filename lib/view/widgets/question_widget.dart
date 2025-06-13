import 'package:flutter/material.dart';

class questionWidget extends StatelessWidget {
  String Question;
  questionWidget({required this.Question});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xff18222E),
              border: Border.fromBorderSide(
                BorderSide(
                  color: Colors.white,
                  width: 0.7,
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(0),
              ),
            ),
            child: Text(
              Question,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
             maxLines: null,
            ),
          ),
        ),
      ],
    );
  }
}