import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/user_dao.dart';
import 'package:vqa_app/firebase_error_codes/firebase_error_codes.dart';
import 'package:vqa_app/utils/email_format.dart';
import 'package:vqa_app/view/home/home_screen.dart';
import 'package:vqa_app/view/home/register/register_screen.dart';
import 'package:vqa_app/view/widgets/custom_text_form_field.dart';

import '../../../utils/dialog_utils.dart';

class loginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool obsecureText = true;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/splash_screen_background.png'),
              fit: BoxFit.fill
          )
      ) ,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Container(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Center(child: Image.asset('assets/images/logo.png',))),
                  customTextFormField(labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    controller: emailController,
                    validator: (input) {
                      if(input == null || input.isEmpty){
                        return ' Please Enter Email';
                      }
                      if( !isEmailFormatter(input)){
                        return 'Please Enter a Valid Email Address';
                      }
                      return null;
                    },
                  ),
                  customTextFormField(labelText: 'Password',
                      suffixIcon: IconButton(onPressed: () {
                        if(obsecureText == true){
                          obsecureText = false;
                        }else{
                          obsecureText =true;
                        }
                        setState(() {

                        });
                      }, icon: Icon(Icons.remove_red_eye_outlined)),
                      prefixIcon: Icon(Icons.password),
                      maxLines: 1,
                      obsecureText:obsecureText,
                      controller: passwordController,
                      validator: (input) {
                        if(input == null || input.isEmpty){
                          return ' Please Enter Password';
                        }
                        if(input.length < 6){
                          return 'Pasword must be at least 6 characters';
                        }
                        return null;
                      }
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: ElevatedButton(onPressed: () {
                      login();
                    },
                      child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ?",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,),),
                      SizedBox(width:5),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, registerScreen.routeName);
                          },
                          child: Text('Signup',style: TextStyle(color: Color(0xff3C5D91),fontWeight: FontWeight.w600,),)
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async{
    var authProvider = Provider.of<MyAuthProvider>(context,listen: false);

    if (formKey.currentState?.validate() == false) {
      return;
    }
    try {
      DialogUtils.showLoadingDialog(context, 'Loading...');
      await authProvider.login(emailController.text, passwordController.text);
      DialogUtils.hideDialog(context);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.userNotFound) {
        DialogUtils.showMessage(context, 'Wrong Email',postiveActionTitle: 'Ok');
      } else if (e.code == FirebaseErrorCodes.wrongPassword) {
        DialogUtils.showMessage(context, 'Password',postiveActionTitle: 'Ok');
      }
    }
  }
}
