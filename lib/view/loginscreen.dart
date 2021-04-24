import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainscreen.dart';
import '../registrationscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _eController = new TextEditingController();
  TextEditingController _pController = new TextEditingController();
  SharedPreferences prefs;
  double screenHeight, screenWidth;
  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child:
                      Image.asset('assets/images/chngrojak.jpg', scale: 0.5)),
              SizedBox(height: 5),
              Text(
                        'Login',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
              Container(
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                  child: Column(
                    children: [
                      TextField(
                        controller: _eController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email)),
                      ),
                      TextField(
                        controller: _pController,
                        decoration: InputDecoration(
                            labelText: 'Password', icon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.black,
                              activeColor: Colors.red,
                              value: _rememberMe,
                              onChanged: (bool value) {
                                _onChange(value);
                              }),
                          Text("Remember Me")
                        ],
                      ),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minWidth: screenWidth,
                          height: 50,
                          child: Text('Login',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: _onLogin,
                          color: Colors.red),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Text("Register New Account",
                    style: TextStyle(fontSize: 16)),
                onTap: _registerNewUser,
              ),
              SizedBox(height: 10),
              GestureDetector(
                child: Text("Forgot Password", style: TextStyle(fontSize: 16)),
                onTap: _forgotPassword,
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _onLogin() async {
  
    String _email = _eController.text.toString();
    String _password = _pController.text.toString();
    http.post(
        Uri.parse("https://kejunbo.com/chngrojak/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        
      } else {
        Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
  

        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen()));
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailcontroller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forgot Your Password?"),
            content: new Container(
                height: 100,
                child: Column(
                  children: [
                    Text("Enter your recovery email"),
                    TextField(
                      controller: _useremailcontroller,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    )
                  ],
                )),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.red),
                child: Text("Submit", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  print(_useremailcontroller.text);
                  _resetPassword(_useremailcontroller.text.toString());
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.white, backgroundColor: Colors.red),
                                    child: Text("Cancel", style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          });
                    }
                  
                    void _onChange(bool value) {
                      String _email = _eController.text.toString();
                      String _password = _pController.text.toString();
                  
                      if (_email.isEmpty || _password.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Email/password is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      setState(() {
                        _rememberMe = value;
                        storePref(value, _email, _password);
                      });
                    }
                  
                    Future<void> storePref(bool value, String email, String password) async {
                      prefs = await SharedPreferences.getInstance();
                      if (value) {
                        await prefs.setString("email", email);
                        await prefs.setString("password", password);
                        await prefs.setBool("rememberme", value);
                        Fluttertoast.showToast(
                            msg: "Email and Password Saved",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      } else {
                        await prefs.setString("email", '');
                        await prefs.setString("password", '');
                        await prefs.setBool("rememberMe", value);
                        Fluttertoast.showToast(
                            msg: "Email and Password Saved are Removed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16
                            );
                        setState(() {
                          _eController.text = "";
                          _pController.text = "";
                          _rememberMe = false;
                        });
                        return;
                      }
                    }
                  
                    Future<void> loadPref() async {
                      prefs = await SharedPreferences.getInstance();
                      String _email = prefs.getString("email") ?? '';
                      String _password = prefs.getString("password") ?? '';
                      _rememberMe = prefs.getBool("rememberme") ?? false;
                  
                      setState(() {
                        _eController.text = _email;
                        _pController.text = _password;
                      });
                    }
                  
                    void _resetPassword(String string) {}
}
