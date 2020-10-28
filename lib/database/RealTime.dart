import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class FireBaseFireStoreDemo extends StatefulWidget {
  FireBaseFireStoreDemo() : super();

  final String title = "CloudFireStore Demo";
  @override
  FireBaseFireStoreDemoState createState() => FireBaseFireStoreDemoState();
}

class FireBaseFireStoreDemoState extends State<FireBaseFireStoreDemo> {
  //
  bool showTextField = false;
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController contactController = TextEditingController();
  String collectionName = "packages";
  bool isEditing = false;
  User curUser;



  getUsers() {
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }

  addUser() {
    User user = User(title: controller.text , details: controller1.text  , price: contactController.text);
    try {
      FirebaseFirestore.instance.runTransaction(
            (Transaction transaction) async {
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc()
              .set(user.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  add() {
    if (isEditing) {
      // Update
      update(curUser, controller.text , controller1.text , contactController.text);
      setState(() {
        isEditing = false;
      });
    } else {
      addUser();
    }
    controller.text = '';
    controller1.text = '';
    contactController.text = '';
  }

  update(User user, String newName , String newLastName, String newPhoneNumber) {
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(user.reference, {'name': newName , 'lastName':newLastName , 'contactInfo':newPhoneNumber});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  delete(User user) {
    FirebaseFirestore.instance.runTransaction(
          (Transaction transaction) async {
        transaction.delete(user.reference);
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.hasData) {
          print("The number of documents are ${snapshot.data.docs.length}");
          return buildList(context, snapshot.data.docs);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final user = User.fromSnapshot(data);
    return Padding(
      key: ValueKey(user.title),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                 InkWell(
                    onTap: () {
                      setUpdateUI(user);
                      },
                   child: Container(
                     height: 100,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: Color(0xFFBAC1C7),
                       borderRadius: BorderRadius.circular(15.0
                       ),
                       shape: BoxShape.rectangle,
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               Text(user.title , style : TextStyle( color: Colors.black , fontSize: 20)),
                               Expanded(
                                   child: Text(user.details, style : TextStyle( color: Colors.black , fontSize: 20))),
                             ],
                           ),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Text(user.price, style : TextStyle( color: Colors.black , fontSize: 20)),
                             ],
                           ),
                       IconButton(
                             icon: Icon(Icons.delete),
                             onPressed: () {
                               delete(user);
                             },
                           ),
                         ],
                       ),
                     ),

                   ),
                 ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setUpdateUI(User user) {
    controller.text = user.title;
    setState(() {
      showTextField = true;
      isEditing = true;
      curUser = user;
    });
  }

  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(isEditing ? "UPDATE" : "ADD"),
        onPressed: () {
          add();
          setState(() {
            showTextField = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                showTextField = !showTextField;
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showTextField
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: "Name", hintText: "Enter name"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller1,
                  decoration: InputDecoration(
                      labelText: "Last Name", hintText: "Enter last name"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: contactController,
                  decoration: InputDecoration(
                      labelText: "Phone Number", hintText: "Enter Number"),
                ),
                button(),
              ],
            )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Text(
              "USERS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            ),
          ],
        ),
      ),
    );
  }
}