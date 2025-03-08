import 'package:flutter/material.dart';
import 'package:vqa_app/utils/email_format.dart';
import 'package:vqa_app/view/home/register/register_screen.dart';
import 'package:vqa_app/view/widgets/custom_text_form_field.dart';

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
        body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 106,left: 135,right: 135),
                    child: Image.asset('assets/images/logo.png',)),
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
    );
  }

  void login() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
  }
}
