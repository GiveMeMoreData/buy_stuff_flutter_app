
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


class Party{

  @protected
  String name;

  @protected
  String inviteCode;

  @protected
  DateTime created;

  @protected
  Map usersMap;

  @protected
  Map info;

  @protected
  Map needs;

  @protected
  Map style;

  void setName(String newDeviceName) {
    name = newDeviceName;
  }
  void setUsers(Map newUsers){
    usersMap = newUsers;
  }
  void addUser(String newUserId){
    usersMap.putIfAbsent(newUserId, () => []);
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

  Party({this.name, this.inviteCode, this.created, this.usersMap, this.info, this.needs, this.style});
}


abstract class PartyListBase{

  @protected
  Map<String,Party> partiesMap;

  @protected
  Map<String,Party> initialPartiesMap;


  Map<String,Party> get currentPartiesMap => partiesMap;

  void setPartiesMapFromDocumentSnapshotList(List<DocumentSnapshot> newParties){
    restart();
    for(DocumentSnapshot party in newParties){
      partiesMap.putIfAbsent(party.documentID, () =>  new Party(
          name: party['name'],
          inviteCode: party['invite_code'],
          created: DateTime.fromMillisecondsSinceEpoch(party['created'].millisecondsSinceEpoch),
          usersMap: party['users_map'],
          info: party['info'],
          needs: party['needs'],
          style: party['style']
      ));
    }
  }

  void addNeed(String partyId, String need, String importance){
    partiesMap[partyId].needs[importance].add(need);
  }
  void removeNeed(String partyId, String need, String importance){
    partiesMap[partyId].needs[importance].remove(need);
  }

  void removeNeedsFromMap(String partyId, Map updateData){
    for(String _importance in updateData.keys.toList()){
      for (String _need in updateData[_importance]){
        removeNeed(partyId, _need, _importance);
      }
    }
  }

  void addPartyFromAddData(String partyId, Map addData){
    partiesMap.putIfAbsent(partyId, () => new Party(
        name: addData['name'],
        inviteCode: generateInviteCode(),
        created: addData['created'],
        usersMap: addData['users'],
        info: addData['info'],
        needs: addData['needs'],
        style: addData['style']));
  }


  String generateInviteCode(){
    return "aaaaaa";
  }

  void restart() {
    initialPartiesMap = {};
    partiesMap = initialPartiesMap;
  }
}


class PartyListState extends PartyListBase {
  static final PartyListState _instance = PartyListState._internal();

  factory PartyListState() {
    return _instance;
  }

  PartyListState._internal() {
    initialPartiesMap = {};
    partiesMap = initialPartiesMap;
  }
}

