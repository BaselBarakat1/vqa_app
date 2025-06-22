import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vqa_app/auth_provider/auth_provider.dart';
import 'package:vqa_app/database/model/user.dart'as myUser;
import 'package:vqa_app/database/user_dao.dart';
import 'package:vqa_app/firebase_error_codes/firebase_error_codes.dart';
import 'package:vqa_app/utils/email_format.dart';
import 'package:vqa_app/view/home/login/login_screen.dart';
import 'package:vqa_app/view/widgets/custom_text_form_field.dart';

import '../../../utils/dialog_utils.dart';

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
  bool obsecureText = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash_screen_background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Create Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white), // Make back button white
        ),
        body: SingleChildScrollView( // Moved SingleChildScrollView to body level
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add top spacing
                  SizedBox(height: 20),

                  // Logo with responsive sizing
                  Container(
                    padding: EdgeInsets.only(bottom: 30), // Reduced padding
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width * 0.25, // Smaller for register
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ),
                  ),

                  // User Name field
                  customTextFormField(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person_outline),
                    controller: userNameController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter User Name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16), // Add spacing between fields

                  // Email field
                  customTextFormField(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    controller: emailController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter Email';
                      }
                      if (!isEmailFormatter(input)) {
                        return 'Please Enter a Valid Email Address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Password field
                  customTextFormField(
                    labelText: 'Password',
                    maxLines: 1,
                    prefixIcon: Icon(Icons.lock_outline), // Better icon
                    controller: passwordController,
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText; // Simplified toggle
                        });
                      },
                      icon: Icon(obsecureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined), // Better icons
                    ),
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter Password';
                      }
                      if (input.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Password Confirmation field
                  customTextFormField(
                    labelText: 'Password Confirmation',
                    maxLines: 1,
                    prefixIcon: Icon(Icons.lock_outline), // Better icon
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText; // Simplified toggle
                        });
                      },
                      icon: Icon(obsecureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined), // Better icons
                    ),
                    controller: passwordConfirmationController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter Password Confirmation';
                      }
                      if (input.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (input != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  // Create Account button
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 32), // Increased padding
                    child: ElevatedButton(
                      onPressed: () {
                        createAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16), // Better button height
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16, // Slightly larger text
                        ),
                      ),
                    ),
                  ),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, loginScreen.routeName);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xff3C5D91),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),

                  // Add bottom spacing for keyboard
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    if (formKey.currentState?.validate() == false) {
      return;
    }
    try {
      DialogUtils.showLoadingDialog(context, 'Loading...');
      await authProvider.register(userNameController.text, emailController.text, passwordController.text); // Add await
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'Account Created Successfully',
        icon: Icon(Icons.check_circle, color: Colors.green),
        postiveActionTitle: 'Ok',
        posAction: () {
          Navigator.pushReplacementNamed(context, loginScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context); // Make sure to hide dialog on error
      if (e.code == FirebaseErrorCodes.weakPassword) {
        DialogUtils.showMessage(context, 'The password provided is too weak.', postiveActionTitle: 'Ok');
      } else if (e.code == FirebaseErrorCodes.emailAlreadyInUse) {
        DialogUtils.showMessage(context, 'The account already exists for that email.', postiveActionTitle: 'Ok');
      }
    } catch (e) {
      DialogUtils.hideDialog(context); // Make sure to hide dialog on error
      DialogUtils.showMessage(context, 'Something went wrong.', postiveActionTitle: 'Ok');
    }
  }
}