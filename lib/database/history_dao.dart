import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vqa_app/database/model/history.dart';
import 'package:vqa_app/database/user_dao.dart';

class historyDao{

  static CollectionReference<History> getHistoryCollecton(String uid){
    return userDao.getUsersCollection().doc(uid).collection(History.collectionName).
    withConverter(
      fromFirestore: (snapshot, options) => History.fromFireStore(snapshot.data()),
      toFirestore: (history, options) =>history.toFireStore() ,);
  }
  static Future<void> addHistory(String uid, History history){
    var historyCollection = getHistoryCollecton(uid);
    var docRef = historyCollection.doc();
    history.id = docRef.id;
    return docRef.set(history);
  }
  static Future<List<History>> getAllHistories(String uid)async{ // one time read
    var historyCollection = getHistoryCollecton(uid);
    var snapShot = await historyCollection.get();
    return snapShot.docs.map((e) => e.data()).toList();
  }
  static Stream<List<History>> listenForHistories(String uid) async* {
    var historyCollection = getHistoryCollecton(uid);
    var stream = historyCollection.snapshots();
    yield* stream.map((querySnapshot) => querySnapshot.docs.map((e) => e.data()).toList());
  }
  static Future<void> deleteHistory( String uid , String historyId ){
    var historyCollection = getHistoryCollecton(uid);
    return historyCollection.doc(historyId).delete();
  }

}