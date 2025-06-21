import 'dart:io';

class History{
  String? id;
  String? question;
  File? imageFile;
  String? answer;
  static const String collectionName = 'Histories';

  History({this.question,this.imageFile,this.answer,this.id});

  Map<String,dynamic> toFireStore(){
    return {
      'id' : id,
      'question' : question,
      'imageFile' : imageFile?.path,
      'answer' : answer,
    };
  }
  History.fromFireStore(Map<String,dynamic>? data) : this(
    id: data?['id'],
    question: data?['question'],
    imageFile: data?['imageFile'],
    answer: data?['answer'],
  );
}