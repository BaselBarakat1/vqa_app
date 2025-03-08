import 'package:flutter/material.dart';
import 'package:vqa_app/utils/email_format.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';
import 'package:vqa_app/view/widgets/custom_text_form_field.dart';

class registerScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordConfirmationController = TextEditingController();

  bool obsecureText= true;

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
        appBar: AppBar(
          title: Text('Create Account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 42,left: 135,right: 135),
                    child:Image.asset('assets/images/logo.png',) ,
                  ),
                  customTextFormField(labelText: 'User Name',
                    prefixIcon: Icon(Icons.person_outline),
                    controller: userNameController,
                    validator: (input) {
                      if(input == null || input.isEmpty){
                        return ' Please Enter User Name';
                      }
                      return null;
                    },
                  ),
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
                    maxLines: 1,
                    prefixIcon: Icon(Icons.password),
                    controller: passwordController,
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(onPressed: () {
                      if(obsecureText == true){
                        obsecureText = false;
                      }else{
                        obsecureText =true;
                      }
                      setState(() {
              
                      });
                    }, icon: Icon(Icons.remove_red_eye_outlined)),
                    validator: (input) {
                      if(input == null || input.isEmpty){
                        return ' Please Enter Password';
                      }
                      if(input.length < 6){
                        return 'Pasword must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  customTextFormField(labelText: 'Password Confirmation',
                    maxLines: 1,
                    prefixIcon: Icon(Icons.password),
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(onPressed: () {
                      if(obsecureText == true){
                        obsecureText = false;
                      }else{
                        obsecureText =true;
                      }
                      setState(() {
              
                      });
                    }, icon: Icon(Icons.remove_red_eye_outlined)),
                    controller: passwordConfirmationController,
                    validator: (input) {
                      if(input == null || input.isEmpty){
                        return ' Please Enter Password Confirmation';
                      }
                      if(input.length < 6){
                        return 'Pasword must be at least 6 characters';
                      }
                      if(input != passwordController.text){
                        return 'Password Not Match';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: ElevatedButton(onPressed: () {
                      createAccount();
                    },
                      child: Text('Create Account',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account ?",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,),),
                      SizedBox(width:5),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, loginScreen.routeName);
                          },
                          child: Text('Login',style: TextStyle(color: Color(0xff3C5D91),fontWeight: FontWeight.w600,),)
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

  void createAccount() {
    if(formKey.currentState?.validate() == false){
      return;
    }
  }
}
