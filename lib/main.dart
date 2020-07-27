import 'package:buystuff/cache/singletons.dart';
import 'package:buystuff/groups/new_group.dart';
import 'package:buystuff/groups/shopping.dart';
import 'file:///C:/Users/Bartek/AndroidStudioProjects/buy_stuff/lib/groups/group.dart';
import 'package:buystuff/home_screen.dart';
import 'package:buystuff/login/login_main.dart';
import 'package:buystuff/party/new_party.dart';
import 'package:buystuff/party/parties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(buttonColor: Color.fromARGB(255, 79, 206, 239)),
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      routes: {
        '/': (context) => LoadingScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginMain.routeName: (context) => LoginMain(),
        RegisterMain.routeName: (context) => RegisterMain(),
        GroupMain.routeName: (context) => GroupMain(),
        GroupShopping.routeName: (context) => GroupShopping(),
        AddGroup.routeName: (context) => AddGroup(),
        PartyMain.routeName: (context) => PartyMain(),
        AddParty.routeName: (context) => AddParty(),
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingScreenState();

}

class _LoadingScreenState extends State<LoadingScreen> {

  final GroupListBase groups = GroupListState();
  final PartyListBase parties = PartyListState();

  Future loadCurrentUser() async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser == null){
      Navigator.pop(context);
      Navigator.pushNamed(context, LoginMain.routeName);
    } else {
      await loadGroups(currentUser.uid);
      await loadParties(currentUser.uid);
      loadRequests(currentUser.uid);
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.routeName);
    }
  }


  Future<Null> loadGroups(String userId) async {
    final query = await Firestore.instance.collection('groups').where('users', arrayContains: userId).getDocuments();
    groups.setGroupsMapFromDocumentSnapshotList(query.documents);
  }

  Future<Null> loadParties(String userId) async {
    final query = await Firestore.instance.collection('parties').where('users', arrayContains: userId).getDocuments();
    parties.setPartiesMapFromDocumentSnapshotList(query.documents);

  }

  void loadRequests(String userId){

  }


@override
  void initState() {
    loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Image(
          image: AssetImage("assets/logo.png"),

        ),
      ),
    );
  }



}