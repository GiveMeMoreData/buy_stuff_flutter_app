
import 'dart:ui';

import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/group.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/templates/templates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vector_math/vector_math.dart' as math;


class AddGroup extends StatefulWidget{
  static const routeName = "/Groups/Add";
  @override
  State<StatefulWidget> createState() => _AddGroupState();

}


class _AddGroupState extends State<AddGroup>{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Dodaj grupę"),),

        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(FindGroup.routeName).then((value) => setState((){}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.grey
                            )
                          ]
                      ),
                      child: Center(
                        child: Text(
                          "Dołącz do grupy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1,),
                Flexible(
                  flex: 5,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(CreateGroup.routeName).then((value) => setState((){}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0,-3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.grey
                          )
                        ]
                      ),

                      child: Center(
                        child: Text(
                          "Stwórz grupę",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
  }

}


class CreateGroup extends StatefulWidget{
  static const routeName = '/Group/Create';
  @override
  State<StatefulWidget> createState() => _CreateGroupState();


}


class _CreateGroupState extends State<CreateGroup>{

  final GroupListBase groups = GroupListState();

  String _colorKey = "cyan";
  String _groupName = "";
  double buttonHeight = -200;


  void checkIfCanCreate(){
    if(_groupName == "") {
      buttonHeight = -200;
    } else {
      buttonHeight = 20;
    }
  }

  final colorsMap = {
    "black" : Colors.black,
    "yellow" : Colors.yellowAccent,
    "red" : Colors.red,
    "green" : Colors.green,
    "cyan" : Colors.cyan,
    "purple" : Colors.purple,
    "pink" : Colors.pink,
  };

  Widget CircularColorChoice(int index) {
    final _circleRadious = 35.0;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_circleRadious),
        ),
        width: 2.5*_circleRadious,
        height: 2.5*_circleRadious,
        child: Center(
          child: CustomPaint(painter: DrawCircle(colorsMap.values.toList()[index], radius: _circleRadious),
          ),
        ),
      ),
      onTap: (){
        print("color changed");
        setState(() {
          _colorKey = colorsMap.keys.toList()[index];
        });
      },
    );

  }

  Future<Null> createGroup() async {
    final userId = await FirebaseAuth.instance.currentUser();
    final newGroupData = {
      "created" : DateTime.now(),
      "name": _groupName,
      "needs" : {"1" : [], "2" : [], "3" : []},
      "style" : { "color" : _colorKey },
      "users" : [userId.uid],
    };

    await Firestore.instance.collection('groups').add(newGroupData).then(
            (document) => {
              groups.addGroupFromAddData(document.documentID, newGroupData),
            });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfCanCreate();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Text(
                              "Nowa grupa",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                color: colorsMap[_colorKey],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Container(height: MediaQuery.of(context).size.height*0.03,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Center(
                        child: TextField(
                          textAlign: TextAlign.center,
                          onChanged: (newGroupName){
                            _groupName = newGroupName;
                          },
                          decoration: InputDecoration(
                            hintText: "Nazwa",
                            hintStyle: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Colors.black26,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Container(height: MediaQuery.of(context).size.height*0.06,),
                    Container(
                      height: MediaQuery.of(context).size.height*0.06,
                      child: Text(
                        "Krótki opis",
                         style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.black26,

                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration.collapsed(
                            hintText: "Dodaj opis...",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.06,
                      child: Text(
                        "Motyw",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.black26,

                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: colorsMap.keys.toList().length,
                          itemBuilder: (_, int index){
                            return CircularColorChoice(index);
                          },
                        ),
                      ),
                    )
                  ],
                ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              bottom: buttonHeight,
              child: RaisedButton(
                color: colorsMap[_colorKey],
                splashColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () async {
                  await createGroup();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    "Stwórz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


class FindGroup extends StatefulWidget{
  static const routeName = "/Groups/Join";
  @override
  State<StatefulWidget> createState() => _FindGroupState();

}

class _FindGroupState extends State<FindGroup>{

  bool _canSearch = false;
  String _inviteCode = '';
  String userId;

  final GroupListBase groups = GroupListState();

  Future<Null> reloadDownloadedGroups(String userId) async {
    final query = await Firestore.instance.collection('groups').where('users', arrayContains: userId).getDocuments();
    groups.setGroupsMapFromDocumentSnapshotList(query.documents);
  }

  void addToTarget() async {

    final inviteDocument = await Firestore.instance.collection('invites').document(_inviteCode).get();
    if(inviteDocument.data == null){
      showResponseDialog("Nie znaleziono grupy związanej z podanym kodem");
      print("No invite with given code");
      return;
    }

    if(inviteDocument.data['active'] == false){
      showResponseDialog("Ten kod dołączenia został wyłączony");
      print("This invite code is inactive");
      return;
    }

    final target = await Firestore.instance.collection(inviteDocument.data['type']).document(inviteDocument.data['target']).get();

    if(target.data == null){
      showResponseDialog("Grupa, do której prowadzi ten kod już nie istnieje");
      print("Invite code does not lead to proper target");
    }
    List currentTargetUsers = target.data['users'];
    if(currentTargetUsers.contains(userId)){
      showResponseDialog("Jesteś już członkiem tej grupy");
      print("User already in target");
      return;
    }
    currentTargetUsers.add(userId);
    Map<String,dynamic> updateData = {
      'users' : currentTargetUsers,
    };

    Firestore.instance.collection(inviteDocument.data['type']).document(target.documentID).setData(updateData, merge: true);

    // todo somehow show positive response
    print("Group found!");

    await reloadDownloadedGroups(userId);
    Navigator.of(context).popUntil((route) => route.settings.name == HomeScreen.routeName);
  }

  void loadCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    userId = user.uid;
  }


  void showResponseDialog(String message) {

    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.1),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOut.transform(anim1.value)- 1.0;
          return Transform(
          transform: Matrix4.translationValues(0, curvedValue*200, 0),
          child: Opacity(
            opacity: anim1.value>0.5? 1 : anim1.value + 0.5,
            child: Dialog(
              elevation: 30,
              backgroundColor: Colors.transparent,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width*0.6,
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey[300].withOpacity(0.95),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, size: 32, color: Colors.black54,),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 28,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ),
        );
        },
        transitionDuration: Duration(milliseconds: 300)
    );
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              TextField(
                textAlign: TextAlign.center,
                maxLength: 6,
                maxLines: 1,
                cursorColor: Colors.deepPurpleAccent.withOpacity(0.4),
                onChanged: (code){
                  _inviteCode = code;
                  if(code.length == 6){
                    _canSearch = true;
                  } else{
                    _canSearch = false;
                  }
                },
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  letterSpacing: 1,
                ),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.cyan,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "kod",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 20,
            child: MaterialButton(
              elevation: _canSearch? 10: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                decoration: BoxDecoration(
                  color: _canSearch? Colors.deepPurpleAccent : Colors.deepPurpleAccent.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Znajdź",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              onPressed: (){
                if(_canSearch && userId != null){
                  addToTarget();
                }
              },
            ),

          )
        ],
      ),
    );
  }

}


