import 'dart:io';

class History{
  String? id;
  String? question;
  String? imageUrl;
  String? answer;
  static const String collectionName = 'Histories';

  History({this.question,this.imageUrl,this.answer,this.id});

  Map<String,dynamic> toFireStore(){
    return {
      'id' : id,
      'question' : question,
      'imageUrl' : imageUrl,
      'answer' : answer,
    };
  }
  History.fromFireStore(Map<String,dynamic>? data) : this(
    id: data?['id'],
    question: data?['question'],
    imageUrl: data?['imageUrl'],
    answer: data?['answer'],
  );
}