
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Group{

  @protected
  String name;

  @protected
  List<dynamic> users;

  @protected
  DateTime created;

  @protected
  Map needs;

  @protected
  Map style;






  void setName(String newDeviceName) {
    name = newDeviceName;
  }
  void setUsers(List<String> newUsers){
    users = newUsers;
  }
  void addUser(String newUserId){
    users.add(newUserId);
  }

  void setNeeds(Map newNeeds){
    needs = newNeeds;
  }

  void addNeed(int importance, String needName){
    needs[importance].add(needName);
  }
  void setStyle(Map newStyle){
    style = newStyle;
  }

  Group(this.name, this.users, this.created, this.needs, this.style);
}


abstract class GroupListBase{

  @protected
  Map<String,Group> groupsMap;

  @protected
  Map<String,Group> initialGroupsMap;


  Map<String,Group> get currentGroupsMap => groupsMap;

  void setGroupsMapFromDocumentSnapshotList(List<DocumentSnapshot> newGroups){
    restart();
    for(DocumentSnapshot group in newGroups){
      groupsMap.putIfAbsent(group.documentID, () =>  new Group(
          group['name'],
          group['users'],
          DateTime.fromMillisecondsSinceEpoch(group['created'].millisecondsSinceEpoch),
          group['needs'],
          group['style']
      ));
    }
  }

  void addNeed(String need, String importance){

  }
  void removeNeed(String groupId,String need, String importance){
    groupsMap[groupId].needs[importance].remove(need);
  }

  void removeNeedsFromMap(String groupId, Map updateData){
    for(String _importance in updateData.keys.toList()){
      for (String _need in updateData[_importance]){
        removeNeed(groupId, _need, _importance);
      }
    }
  }

  void addGroupFromAddData(String groupId, Map addData){
    groupsMap.putIfAbsent(groupId, () => new Group(addData['name'], addData['users'], addData['created'], addData['needs'], addData['style']));
  }

  void restart() {
    initialGroupsMap = {};
    groupsMap = initialGroupsMap;
  }
}


class GroupListState extends GroupListBase {
  static final GroupListState _instance = GroupListState._internal();

  factory GroupListState() {
    return _instance;
  }

  GroupListState._internal() {
    initialGroupsMap = {};
    groupsMap = initialGroupsMap;
  }
}


class ColorsPalette {
  final map = {
    "black" : Colors.black,
    "yellow" : Colors.yellowAccent,
    "red" : Colors.red,
    "green" : Colors.green,
    "cyan" : Colors.cyan,
    "lightBlue" : Colors.lightBlue,
    "purple" : Colors.purple,
    "pink" : Colors.pink,
  };
}
