import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vqa_app/database/model/user.dart' as MyUser;
import 'package:vqa_app/database/user_dao.dart';

class MyAuthProvider extends ChangeNotifier{
  MyUser.User? databaseUser;
  User? firebaseAuthUser;

  register(String userName,String email,String password) async {
    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userDao.addUser(MyUser.User(
      id: credential.user?.uid,
      userName: userName,
      email: email,
    ));
  }
  login(String email,String password) async {
    var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
   var user = await userDao.getUser(credential.user!.uid);
   databaseUser = user;
   firebaseAuthUser = credential.user;
  }
}