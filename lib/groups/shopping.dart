

import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/templates/templates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupShopping extends StatefulWidget{
  static const routeName = '/Group/Shopping';


  @override
  State<StatefulWidget> createState() => _GroupShoppingState();


}


class _GroupShoppingState extends State<GroupShopping>{
  String groupId;
  final GroupListBase groups = GroupListState();
  final ColorsPalette palette = ColorsPalette();

  String newNeed;

  List needsOne;
  List needsTwo;
  List needsThree;

  List inBasket = [];

  void loadAllNeeds(){
    needsOne = groups.groupsMap[groupId].needs["1"];
    needsTwo = groups.groupsMap[groupId].needs["2"];
    needsThree = groups.groupsMap[groupId].needs["3"];
  }

  void buyProductsInBasket() {
    final updateData = {"1":[], "2":[], "3":[]};

    String _need;
    String _importance;
    for (int index in inBasket){
      if (index<needsOne.length){
        _need =  needsOne[index];
        _importance = "1";
      }
      else if (index < needsOne.length + needsTwo.length){
        _need = needsTwo[index- needsOne.length];
        _importance = "2";
      } else {
        _need = needsThree[index- needsOne.length -needsTwo.length];
        _importance = "3";
      }

      updateData[_importance].add(_need);
    }


    groups.removeNeedsFromMap(groupId, updateData);
    updateNeeds();
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

  void updateNeeds() {
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
          alignment: Alignment.bottomCenter,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'zakupy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height*0.81,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView.builder(
                            itemCount: needsOne.length + needsTwo.length + needsThree.length,
                            itemBuilder: (_, int index){
                              return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: GestureDetector(
                                  onTap: (){
                                    print("Need with index $index added to basket");
                                    setState(() {
                                      if (inBasket.contains(index)){
                                        inBasket.remove(index);
                                      } else{
                                        inBasket.add(index);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: inBasket.contains(index)? Colors.black.withAlpha(30): Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                  width: 26,
                                                  child: Center(child: CustomPaint(painter: inBasket.contains(index)?
                                                                                            DrawCircle(index<needsOne.length? Colors.redAccent : index<needsTwo.length +needsOne.length? Colors.orangeAccent : Colors.blueGrey):
                                                                                            DrawRing(index<needsOne.length? Colors.redAccent : index<needsTwo.length +needsOne.length? Colors.orangeAccent : Colors.blueGrey),)))
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
                                ),
                              );
                            }
                        ),
                      ),
                    ),

                  ],
                )
            ),
            Positioned(
              bottom: 20,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: palette.map[groups.groupsMap[groupId].style['color']],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Center(
                      child: Text(
                        "Zakończ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).pop();
                  buyProductsInBasket();
                },
              ),
            ),
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


