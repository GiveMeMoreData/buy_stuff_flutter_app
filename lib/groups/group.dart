

import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/shopping.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/templates/templates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GroupMain extends StatefulWidget{
  static const routeName = '/Group/Main';


  @override
  State<StatefulWidget> createState() => _GroupMainState();


}


class _GroupMainState extends State<GroupMain>{
  String groupId;
  final GroupListBase groups = GroupListState();
  final ColorsPalette palette = ColorsPalette();

  String newNeed;

  List needsOne;
  List needsTwo;
  List needsThree ;

  void loadAllNeeds(){
    needsOne = groups.groupsMap[groupId].needs["1"];
    needsTwo = groups.groupsMap[groupId].needs["2"];
    needsThree = groups.groupsMap[groupId].needs["3"];
  }


  String getNeed(int index){
    if (index<needsOne.length){
      return needsOne[index];
    }
    if (index < needsOne.length + needsTwo.length){
      return needsTwo[index- needsOne.length];
    }
    return needsThree[index- needsOne.length -needsTwo.length];
  }

  void addNeedToDatabse() {
    final firestore = Firestore.instance;
    final updateData = {
      'needs' : groups.groupsMap[groupId].needs,
    };
    firestore.collection('groups').document(groupId).setData(updateData, merge: true);
  }

  void loadArgs() async {
    Future.delayed(Duration.zero, (){
    });
  }


  @override
  void initState() {
    super.initState();
    loadArgs();
  }

  @override
  Widget build(BuildContext context) {
    groupId = ModalRoute.of(context).settings.arguments;
    loadAllNeeds();
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
                    height: MediaQuery.of(context).size.height*0.15,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Text(
                              groups.groupsMap[groupId].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                color: palette.map[groups.groupsMap[groupId].style['color']],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.80,
                            height: 2,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.81,
                    child: ListView.builder(
                        itemCount: needsOne.length + needsTwo.length + needsThree.length + 1,
                        itemBuilder: (_, int index){
                              if (index == needsOne.length + needsTwo.length + needsThree.length) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Container(
                                          width: 30,
                                          child: Center(child: CustomPaint(painter: DrawCircle(Colors.black26),)))
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: TextField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: "Dodaj",
                                            hintStyle: TextStyle(
                                              color: Colors.black26,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        ),
                                        onChanged: (newProductText){
                                          newNeed = newProductText;
                                        },
                                        onSubmitted: (_){
                                          needsThree.add(newNeed);
                                          addNeedToDatabse();
                                          newNeed = null;

                                        },
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }else
                              return GestureDetector(
                                onLongPressStart: (progress){
                                  print(progress.localPosition);
                                  // todo delete process

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Row(
                                    children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Container(
                                        width: 26,
                                          child: Center(child: CustomPaint(painter: DrawCircle(index<needsOne.length? Colors.redAccent : index<needsTwo.length +needsOne.length? Colors.orangeAccent : Colors.blueGrey),)))
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Text(

                                        getNeed(index),
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                                  ),
                                ),
                              );
                        }
                    ),
                  ),

                ],
              )
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                elevation: 4,
                backgroundColor: palette.map[groups.groupsMap[groupId].style['color']],
                splashColor: Colors.black,
                onPressed: (){
                  Navigator.of(context).pushNamed(GroupShopping.routeName, arguments: groupId).then((value) => setState((){}));
                },
                child: Icon(Icons.shopping_cart, size: 32, color: Colors.white,),
              ),
            ),
            Positioned(
              top: 35,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.grey,
                iconSize: 32,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),

            )
//            Positioned(
//              bottom: 20,
//              left: 80,
//              child: FloatingActionButton(
//                elevation: 4,
//                backgroundColor: palette.map[groups.groupsMap[groupId].style['color']],
//                splashColor: Colors.black,
//                onPressed: (){
//                  //todo requests
//                },
//                child: Icon(Icons.message, size: 32, color: Colors.white,),
//              ),
//            )
          ],
        ),
      ),
    );
  }

}


