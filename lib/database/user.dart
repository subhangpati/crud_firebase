import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  String title;
  String details;
  String price;
  DocumentReference reference;

  User ({this.title ,  this.details , this.price});

  User.fromMap(Map<String , dynamic>map , {this.reference}){
    title = map['title'];
    details = map['details'];
    price = map['price'];
  }

  User.fromSnapshot(DocumentSnapshot snapShot ) : this.fromMap(snapShot.data() , reference : snapShot.reference);

  toJson(){
    return {'title':title , 'details': details , 'price':price};
  }
}