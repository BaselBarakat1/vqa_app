import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vqa_app/database/model/history.dart';
import 'package:vqa_app/database/user_dao.dart';
import 'package:vqa_app/service/image_upload_service.dart';

class historyDao {
  static CollectionReference<History> getHistoryCollecton(String uid) {
    return userDao.getUsersCollection().doc(uid).collection(History.collectionName).withConverter(
      fromFirestore: (snapshot, options) => History.fromFireStore(snapshot.data()),
      toFirestore: (history, options) => history.toFireStore(),
    );
  }

  static Future<void> addHistory(String uid, History history, {File? imageFile}) async {
    try {
      // Upload image if provided
      if (imageFile != null) {
        String? imageUrl = await ImageUploadService.uploadImage(imageFile, uid);
        if (imageUrl != null) {
          history.imageUrl = imageUrl;
        }
      }

      var historyCollection = getHistoryCollecton(uid);
      var docRef = historyCollection.doc();
      history.id = docRef.id;
      await docRef.set(history);
    } catch (e) {
      print('Error adding history: $e');
      rethrow;
    }
  }

  static Future<List<History>> getAllHistories(String uid) async {
    var historyCollection = getHistoryCollecton(uid);
    var snapShot = await historyCollection.get();
    return snapShot.docs.map((e) => e.data()).toList();
  }

  static Stream<List<History>> listenForHistories(String uid) {
    var historyCollection = getHistoryCollecton(uid);
    return historyCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  static Future<void> deleteHistory(String uid, String historyId) async {
    try {
      var historyCollection = getHistoryCollecton(uid);

      // Get the history document to retrieve image URL before deletion
      var doc = await historyCollection.doc(historyId).get();
      var history = doc.data();

      // Delete the image from storage if it exists
      if (history?.imageUrl != null && history!.imageUrl!.isNotEmpty) {
        await ImageUploadService.deleteImage(history.imageUrl!);
      }

      // Delete the document
      await historyCollection.doc(historyId).delete();
    } catch (e) {
      print('Error deleting history: $e');
      rethrow;
     }
    }
}