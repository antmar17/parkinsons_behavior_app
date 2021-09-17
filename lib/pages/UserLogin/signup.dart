import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/auth.dart';
String name = "";
String email = "";
String password = "";
String error = "";
final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar:AppBar(
          title:Text("Sign Up!",
            style: TextStyle(
                fontSize: 15.0
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: screenSize.height,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Form(
                key:_formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please Enter all Credentials",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(height: 35),
                    buildName(),
                    SizedBox(height: 20),
                    buildEmail(),
                    SizedBox(height: 20),
                    buildPassword(),
                    Text("$error",style: TextStyle(color: Colors.red)),
                    buildSignUpBtn(context ,this)
                  ],
                ),
              ),
            ),
          ),
        ),
    resizeToAvoidBottomInset: false);
  }
}


Widget buildName() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Name",
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
          validator: (val)=>val!.isEmpty ? "Enter your name ": null,
          onChanged:(val){email = val;} ,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.accessibility,
                color: Colors.blue,
              ),
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
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
          validator: (val) => val!.isEmpty ? " Enter an Email!": null,
          onChanged:(val){email = val;} ,
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
          validator: (val)=> val!.length < 6 ? "Password must be 6 chars long": null,
          onChanged: (val){password = val;},
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

Widget buildSignUpBtn(BuildContext context,_SignUpState parent) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      child: Text(
        'Sign up',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async{
        //Navigator.pop(context);
        if(_formKey.currentState!.validate()){
          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
          if(result!=null){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created succesfully!")));
          }
          else {
            parent.setState(() {
              error = "Couldn't sign up with credentials";
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error while creating account")));
          }
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





