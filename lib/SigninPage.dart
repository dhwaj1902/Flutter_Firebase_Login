import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentication() async {
//    _auth.authStateChanges.lis((user) async {
//      if(user != null){
//        Navigator.pushReplacementNamed(context, "/");
//      }
//    });
    _auth
        .authStateChanges()
        .listen((User user) async {
      if(user != null){
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  navigateToSignupScreen(){
    Navigator.pushReplacementNamed(context, "/signuppage");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  void signin() async {
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{
//        print(_email+ _password);
//        FirebaseUser user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email,
            password: _password
        );
      }
      catch(error){
        showError(error.message);
      }
    }
  }

  showError(String error){
    showDialog(
        context: context,
        builder: (BuildContext context){
      return AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('ok'))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
                child: Image(
                  image: AssetImage("assets/sign_in.png"),
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Provide Input';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                            )
                          ),
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          validator: (input){
                            if(input.length < 6){
                              return 'Password should be 6 char atleast';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          onPressed: signin,
                          child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignupScreen,
                        child: Text(
                          'Create an Account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
