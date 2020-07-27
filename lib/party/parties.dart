

import 'dart:io';

import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/shopping.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/templates/templates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PartyMain extends StatefulWidget{
  static const routeName = '/Parties/Main';

  @override
  State<StatefulWidget> createState() => _PartyMainState();


}


class _PartyMainState extends State<PartyMain>{
  String partyId;

  final PartyListBase parties = PartyListState();
  final ColorsPalette palette = ColorsPalette();
  final FirebaseStorage storage = FirebaseStorage();
  Future<void> downloadUserIcon( ) async {

  }

  Widget userIcon(String userId){
    // todo load icon

    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Icon(Icons.account_circle, size: 36, color: Colors.grey,),
    );
  }


  @override
  Widget build(BuildContext context) {
    partyId = ModalRoute.of(context).settings.arguments;
    final Party party = parties.partiesMap[partyId];
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.04,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Text(
                              parties.partiesMap[partyId].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                color: palette.map[parties.partiesMap[partyId].style['color']],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.80,
                            height: 3,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: party.usersMap.keys.toList().length + 1,
                      itemBuilder: (context, int index){
                        if(index == party.usersMap.keys.toList().length){
                          return IconButton(
                            icon: Icon(Icons.add, size: 36, color: Colors.grey,),
                          );
                        } else {
                          return userIcon(party.usersMap.keys.toList()[index]);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 2,
                            color: Colors.grey[400],
                            offset: Offset(3,3)
                          ),
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[200],
                              offset: Offset(-3,-3)
                          ),
                        ],
                        color: Colors.white12,
                      ),
                      child: Center(
                        child: Text(
                          "Wszystkie rzeczy",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[400],
                              offset: Offset(3,3)
                          ),
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[200],
                              offset: Offset(-3,-3)
                          ),
                        ],
                        color: Colors.white12,
                      ),
                      child: Center(
                        child: Text(
                          "Potrzebne",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[400],
                              offset: Offset(3,3)
                          ),
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[200],
                              offset: Offset(-3,-3)
                          ),
                        ],
                        color: Colors.white12,
                      ),
                      child: Center(
                        child: Text(
                          "Uczestnicy",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 35,
              right: 15,
              child: IconButton(
                icon: Icon(Icons.info_outline, size: 40, color: Colors.black54,),
              ),
            ),
            Positioned(
              top: 35,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 40, color: Colors.black54,),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}



