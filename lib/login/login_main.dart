

import 'package:buystuff/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginMain extends StatefulWidget{
  static const routeName = '/Login/Login';

  @override
  State<StatefulWidget> createState() => _LoadingMainState();

}

class _LoadingMainState extends State<LoginMain>{

  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave (){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print("[INFO] Form is valid");
      print("[INFO] Email: $_email");
      return true;
    }
    return false;
  }

  void signInAndSubmit() async {
    String errorMessage;
    if (validateAndSave()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        print("Signed in ${user.uid}");
        Navigator.of(context).pop();
        Navigator.pushNamed(context, HomeScreen.routeName);
      } catch (e) {
        switch(e.code){
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        formKey.currentState.reset();
        Scaffold.of(formKey.currentContext).showSnackBar(SnackBar(content: Text(errorMessage),));
        print('Error: $e');

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Spacer(flex: 1,),
              Flexible(
                flex: 1,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  width: MediaQuery.of(context).size.width*0.6,
                ),
              ),
              Spacer(flex: 2,),
              Flexible(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (mail) => _email = mail,
                  validator: (mail) => mail.isEmpty? "Proszę wpisać e-mail": null,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (password) => _password = password,
                  validator: (password) => password.isEmpty? "Proszę wpisać hasło": null,
                  decoration: InputDecoration(
                    hintText: "Hasło",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FlatButton(
                  color: Theme.of(context).buttonColor,
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ) ,
                  onPressed: (){
                    signInAndSubmit();
                  },
                  child: Text(
                    "Zaloguj",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: Colors.white
                    ),
                  )
                ),
              ),
              Flexible(
                flex: 1,
                child: FlatButton(
                    color: Colors.grey,
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ) ,
                    onPressed: (){
                      Navigator.of(context).pushNamed(RegisterMain.routeName);
                    },
                    child: Text(
                      "Zarejestruj",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: Colors.white
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class RegisterMain extends StatefulWidget{
  static const routeName = '/Login/Register';

  @override
  State<StatefulWidget> createState() => _RegisterMainState();

}

class _RegisterMainState extends State<RegisterMain>{

  final formKey = new GlobalKey<FormState>();
  String _email;
  String _email_verification;
  String _password;

  String _name;
  String _surname;

  bool validateAndSave (){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print("[INFO] Form is valid");
      print("[INFO] Email: $_email");
      return true;
    }
    return false;
  }

  //todo
  void pushUserToDatabase(String userId) async {
    Map<String, Object> data = {
      "name": _name,
      "surname": _surname,
      "email": _email,
      "user_id": userId,
      "groups": [],
      "parties": [],
      "requests": []
    };

    CollectionReference usersCollection = Firestore.instance.collection('users');
    usersCollection.add(data);
  }


  void registerAndSubmit() async {
    if(validateAndSave()){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        print("Signed in ${user.uid}");
        pushUserToDatabase(user.uid);
        Navigator.pushNamed(context, LoginMain.routeName);
      } catch (e) {
        switch(e.code) {
          case'ERROR_EMAIL_ALREADY_IN_USE':
            print("Error message: ${e.message}");
            Scaffold.of(formKey.currentContext).showSnackBar(SnackBar(content: Text("Ten email jest już przypisany do istniejącego konta"),));

            break;
          default:
            print("Unknown type of error");
            print('Error: $e');
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Spacer(flex: 1,),
              Flexible(
                flex: 1,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  width: MediaQuery.of(context).size.width*0.6,
                ),
              ),
              Spacer(flex: 2,),
              Flexible(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _name = value,
                  validator: (value) => value.isEmpty? "Proszę wpisać imię": null,
                  decoration: InputDecoration(
                    hintText: "Imię",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _surname = value,
                  validator: (value) => value.isEmpty? "Proszę wpisać nazwisko": null,
                  decoration: InputDecoration(
                    hintText: "Nazwisko",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (mail) => _email = mail,
                  validator: (mail) => mail.isEmpty? "Proszę wpisać e-mail": null,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _email_verification = value,
                  validator: (value) => value.isEmpty && value!=_email_verification? "Proszę powtórzyć e-mail": null,
                  decoration: InputDecoration(
                    hintText: "Powtórz e-mail",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (password) => _password = password,
                  validator: (password) => password.isEmpty? "Proszę wpisać hasło": null,
                  decoration: InputDecoration(
                    hintText: "Hasło",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FlatButton(
                    color: Theme.of(context).buttonColor,
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ) ,
                    onPressed: (){
                      registerAndSubmit();
                    },
                    child: Text(
                      "Rejestruj",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: Colors.white
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}