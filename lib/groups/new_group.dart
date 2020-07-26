
import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/group.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/templates/templates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddGroup extends StatefulWidget{
  static const routeName = '/Group/Add';
  @override
  State<StatefulWidget> createState() => _AddGroupState();


}


class _AddGroupState extends State<AddGroup>{

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