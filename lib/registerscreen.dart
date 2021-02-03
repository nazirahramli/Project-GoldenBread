import 'package:flutter/material.dart';
import 'package:goldenbread/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool emailcheck = false;
  bool validateMobile = false;
  String phoneErrorMessage;
  double screenHeight;
  bool _isChecked = false;
  String urlRegister =
      "https://www.seriouslaa.com/goldenbread/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login.jpeg"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          )))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, 2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(3.5),
                              decoration: BoxDecoration(),
                              child: TextFormField(
                                controller: _nameEditingController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Name",
                                  icon: Icon(Icons.person),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.all(3.5),
                              decoration: BoxDecoration(),
                              child: TextField(
                                controller: _emailEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Email",
                                  icon: Icon(Icons.email),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.all(3.5),
                              decoration: BoxDecoration(),
                              child: TextField(
                                controller: _passEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Password",
                                  icon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                              )),
                          Container(
                              padding: EdgeInsets.all(3.5),
                              decoration: BoxDecoration(),
                              child: TextField(
                                controller: _phoneditingController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Phone",
                                  icon: Icon(Icons.phone),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        GestureDetector(
                          onTap: _showEULA,
                          child: Text('I Agree to Terms  ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 115,
                      height: 50,
                      child: Text('Register'),
                      color: Colors.grey[300],
                      textColor: Colors.black,
                      elevation: 10,
                      onPressed: _onRegister,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already register? ",
                            style: TextStyle(fontSize: 16.0)),
                        GestureDetector(
                          onTap: _loginScreen,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        )),
      ),
    );
  }

  void _onRegister() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register Confirmation"),
          content: new Container(
            height: screenHeight / 10,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                            text:
                                "Are you sure wants to register a new account?" //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Yes, Continue"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _register();
                }),
            new FlatButton(
              child: new Text("No, Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            )
          ],
        );
      },
    );
  }

  void _register() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String password = _passEditingController.text;

    String phone = _phoneditingController.text;
    emailcheck = EmailValidator.validate(email);
    validateMobile(String phone) {
      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(pattern);
      if (phone.length == 0) {
        phoneErrorMessage = 'Please enter mobile number';
        return false;
      } else if (!regExp.hasMatch(phone)) {
        phoneErrorMessage = 'Please enter valid mobile number';
        return false;
      }
      return true;
    }

    if (name.length == 0) {
      Toast.show("Please Enter Your Name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (email.length == 0) {
      Toast.show("Please Enter Your Email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (emailcheck == false) {
      Toast.show("Invalid Email Format", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (password.length == 0) {
      Toast.show("Please Enter Your Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (validateMobile(phone) == false) {
      Toast.show(phoneErrorMessage, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of GoldenBread"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement (EULA) is a legal agreement between you and seriouslaa\n\nThis EULA agreement governs your acquisition and use of our MyFurniture software (Software) directly from seriouslaa or indirectly through a seriouslaa authorized reseller or distributor (a Reseller).\n\nPlease read this EULA agreement carefully before completing the installation process and using the MyFurniture software. It provides a license to use the MyFurniture software and contains warranty information and liability disclaimers.\n\nIf you register for a free trial of the MyFurniture software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MyFurniture software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by seriouslaa herewith regardless of whether other software is referred to or described herein. The terms also apply to any seriouslaa updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MyFurniture."
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.red[400],
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
