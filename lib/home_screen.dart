
import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/new_group.dart';
import 'file:///C:/Users/Bartek/AndroidStudioProjects/buy_stuff/lib/groups/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore firestore = Firestore.instance;

  final GroupListBase groups = GroupListState();
  final ColorsPalette palette = ColorsPalette();

  List<PartyArguments> parties= [];


@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 1,),
            Flexible(
              flex: 5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                itemCount: groups.groupsMap.keys.toList().length+1,
                itemBuilder: (context, int index){
                  if (index == groups.groupsMap.keys.toList().length){
                    return Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushNamed(AddGroup.routeName).then((value) => setState((){}));
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlueAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Center(
                              child: Text(
                                "Nowa\ngrupa",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushNamed(GroupMain.routeName,
                            arguments: groups.groupsMap.keys.toList()[index],
                          ).then((value) => setState((){}));
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: palette.map[groups.groupsMap.values.toList()[index].style['color']],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Center(
                              child: Text(
                                groups.groupsMap.values.toList()[index].name,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },

              ),
            ),
            Spacer(flex: 1,),
            Flexible(
              flex: 5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                itemCount: 1,
                itemBuilder: (context, int index){
                  if (index == 0){
                    return Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(78, 0xDF, 0xDF, 0xDF),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Center(
                            child: Text(
                              "Dodaj nową\nimprezę",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(78, 0xDF, 0xDF, 0xDF),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Center(
                            child: Text(
                              parties[index].name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },

              ),
            ),
            Spacer(flex: 1,),
          ],
        ),
      ),
    );
  }
}

//
//class GroupArguments {
//  final name;
//  final groupId;
//  final createdDate;
//  final style;
//  final needs;
//
//  GroupArguments({
//    this.name,
//    this.groupId,
//    this.createdDate,
//    this.style,
//    this.needs,
//  });
//}

class PartyArguments {
  final name;
  final partyId;
  final date;
  final place;
  final needs;
  final users;

  PartyArguments({
    this.name,
    this.partyId,
    this.date,
    this.place,
    this.needs,
    this.users,
  });
}