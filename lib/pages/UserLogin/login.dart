import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:crypt/crypt.dart';



String email = "";
String password = "";
String error = "";
final AuthService _auth = AuthService();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

    @override
    Widget build(BuildContext context) {
      print(Crypt.sha256("pass123").toString());
      Size screenSize = MediaQuery.of(context).size;
      return Scaffold(
        body: SafeArea(
              child: Container(
                width: double.infinity,
                height: screenSize.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text("$error", style: TextStyle(color: Colors.red)),
                      SizedBox(height: 50),
                      buildEmail(),
                      SizedBox(height: 20),
                      buildPassword(),
                      buildLoginBtn(context,this),
                      buildAnonLoginBtn(context),
                      buildSignUpBtn(context)
                    ],
                  ),
                ),
              ),
            ),
          resizeToAvoidBottomInset: false);
    }
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 1, offset: Offset(0, 2))
          ]),
          height: 60,
          child: TextFormField(
            validator: (val) => val!.isEmpty ? "Enter a valid Email": null,
            onChanged:(val)=> email = val ,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 1, offset: Offset(0, 2))
          ]),
          height: 60,
          child: TextFormField(
            validator: (val) {
              if(val!.isEmpty){
                return "Please enter your password";
              }
              else{
                return null;
              }
            },
            onChanged: (val) => password = val,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.blue,
                ),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildLoginBtn(BuildContext context,_LoginState parent) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        child: Text(
          'Log in',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
          if (result == null) {
            parent.setState(() {
              error = "Could not sign in with your credentials";
              print("error signing in");
            });

          }
          else {
              Navigator.pushReplacementNamed(context, '/home');
          }
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blue,
      ),
    );
  }

Widget buildAnonLoginBtn(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      child: Text(
        'Log in as a Guest',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        dynamic result = await _auth.signInAnon();
        if (result == null) {
          print("error signing in");
        }
        else {
          print("signed in");
          print(result.uid);
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blue,
    ),
  );
}

Widget buildSignUpBtn(BuildContext context) {
  return Container(

      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white54,
      ),
    );
  }
