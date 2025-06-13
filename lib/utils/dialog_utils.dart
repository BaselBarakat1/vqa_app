import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog(context,String message,{bool isBarrierDismissible = true}){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: Color(0xff0B182D)),
          SizedBox(width: 20,),
          Text(message,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,)),
        ],
      ),
    ),
    barrierDismissible: isBarrierDismissible ,
    );
  }
  static void hideDialog(context){
    Navigator.pop(context);
  }
  static void showMessage(context,String message,{Icon? icon,bool isBarrierDismissible = true,String? postiveActionTitle,String? negativeActionTitle,
  VoidCallback? posAction,VoidCallback? negAction}){
    List<Widget> actions = [];
    if(postiveActionTitle != null){
      actions.add(TextButton(onPressed: () {
        Navigator.pop(context);
        posAction?.call();
      }, child: Text(postiveActionTitle,style: TextStyle(color: Color(0xff0B182D)),)));
    }
    if(negativeActionTitle != null){
      actions.add(TextButton(onPressed: () {
       Navigator.pop(context);
       negAction?.call();
      }, child: Text(negativeActionTitle,style: TextStyle(color: Color(0xff0B182D)),)));
    }
    showDialog(context: context, builder: (context) => AlertDialog(
      content:Text(message,textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black)) ,
      icon: icon,
      actions: actions,
    ),
    barrierDismissible: isBarrierDismissible,
    );
  }
}