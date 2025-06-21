class User{
  String? id;
  String? userName;
  String? email;

  User({this.id,this.userName,this.email});

  Map<String,dynamic> toFireStore(){
    return {
      'id':id,
      'userName':userName,
      'email':email,
    };
  }
  User.fromFireStore(Map<String,dynamic>? data) : this(
    id: data?['id'],
    userName: data?['userName'],
    email: data?['email'],
  );
}