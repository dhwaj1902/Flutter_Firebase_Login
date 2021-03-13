import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentiation() async{
    _auth.authStateChanges().listen((User user) {
      if(user != null){
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  navigateToSignInScreen(){
    Navigator.pushReplacementNamed(context, "/signinpage");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentiation();
  }

  signup() async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password
        );
        if(userCredential != null) {
//          UserUpdateInfo updateUser = UserUpdateInfo();
//          updateUser.displayName = _name;
//          .updateProfile({String displayName, String photoURL})
          User user = userCredential.user;
          user.updateProfile(displayName: _name);
        }
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
        title: Text('Sign Up'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
                child: Image(
                  image: AssetImage("assets/sign_up.png"),
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
                              return 'Provide a Name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input) => _name = input,
                        ),
                      ),
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          onPressed: signup,
                          child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignInScreen,
                        child: Text(
                          'Alerady have an Account?',
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
