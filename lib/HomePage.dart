import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  bool isSignedIn = false;
  checkAuthentication() async {
//    _auth.authStateChanges.lis((user) async {
//      if(user != null){
//        Navigator.pushReplacementNamed(context, "/");
//      }
//    });
  print("I am here");
    _auth
        .authStateChanges()
        .listen((User user) async {
      if(user == null){
        Navigator.pushReplacementNamed(context, "/signinpage");
      }
      else{
        print("I am here again");
      }
    });
  }

  getuser() async{
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();

    if(firebaseUser != null){
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
    print(this.user);
  }

  signOut() {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
          child: !isSignedIn
              ? CircularProgressIndicator()
              : Column(
            children: [
              Container(
                padding: EdgeInsets.all(50),
                child: Image(
                  image: AssetImage('assets/home.png'),
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.all(50),
                child: Text(
                  "Hello, ${user.displayName}, you are logged in as ${user.email}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  onPressed: signOut,
                  child: Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
