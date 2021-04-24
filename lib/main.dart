import 'dart:async';

import 'package:chngrojak/loginscreen.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(content)=> LoginScreen())));
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Container(margin:EdgeInsets.all(5),
                child: Image.asset('assets/images/chngrojak.jpg',scale: 1,))
            ],
          ),
        ),
      );
  }
}