import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vqa_app/database/model/user.dart';

class userDao{
  static CollectionReference<User>getUsersCollection(){
    return FirebaseFirestore.instance.collection('users').
    withConverter<User>(
      fromFirestore: (snapshot, options) => User.fromFireStore(snapshot.data()),
      toFirestore: (user, options) => user.toFireStore(),
    );
  }
  static Future<void> addUser(User user){
   var usersCollection = getUsersCollection();
   var doc = usersCollection.doc(user.id);
    return doc.set(user);
  }
  static Future<User?> getUser(String uid) async{
    var userCollection = getUsersCollection();
    var doc = userCollection.doc(uid);
    var docSnapshot = await doc.get();
    return docSnapshot.data();
  }
}