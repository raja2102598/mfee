import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import './forgotPass.dart';
import './homepage.dart';
import './loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String deviceToken;

class _LoginPageState extends State<LoginPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _rnumFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  String errMsg = '';
  String status;
  bool Istatus;
  bool loading = false;

  TextEditingController Tuser = TextEditingController();
  TextEditingController Tpass = TextEditingController();

  firebaseCloudMessaging() async {
    String token = await _firebaseMessaging.getToken();
    var g = FieldValue.serverTimestamp();
    deviceToken = token;
  }

  getIStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Istatus = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Istatus = true;
    } else {
      Istatus = false;
    }
  }

  Future userLogin() async {
    bool i = true;
    Tuser.text = Tuser.text.toUpperCase();
    var year = Tuser.text.substring(0, 2);
    var branch = Tuser.text.substring(2, 4);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String p;
    String u;
    String stbatch;
    String stbranch;
    await Firestore.instance
        .collection('Login/$year/$branch')
        .document('${Tuser.text}')
        .get()
        .then((event) async {
      if (event.exists) {
        gbbatch = event.data['batch'];
        gbbranch = event.data['branch'];
        stbranch = gbbranch;
        stbatch = gbbatch;
        p = event.data['pass'];
        u = event.data['user'];
        gbrollNum = event.data['user'];

        if (Tuser.text == u && Tpass.text == p) {
          initializeDateFormatting();
          DateTime now = DateTime.now();
          var dateString = DateFormat('dd-MM-yyyy').format(now);
          TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
          String res = DateFormat("dd-MM-yyyy").format(now) +
              "  " +
              timeOfDay.format(context);
          prefs.setString('batch', event.data['batch']);
          prefs.setString('branch', event.data['branch']);
          prefs.setString('rollNum', Tuser.text.toString());
          prefs.setString('lastlogintime', res);
          prefs.setString('user', Tuser.text.toString());
          prefs.setString('pass', Tpass.text.toString());

          bool firstTime = prefs.getBool('first_time');
          prefs.setBool('first_time', false);
          setState(() {
            Tuser.clear();
            Tpass.clear();
            loading = false;
          });
          Fluttertoast.showToast(
              msg: 'Login Successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            Tuser.clear();
            Tpass.clear();
            loading = false;
          });
          i = false;
        }
      } else {
        setState(() {
          Tuser.clear();
          Tpass.clear();
          loading = false;
        });
        Fluttertoast.showToast(
            msg: 'Username or Password Wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    if (!i)
      Fluttertoast.showToast(
          msg: 'Username or Password Wrong',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  @override
  void dispose() {
    Tuser.dispose();
    Tpass.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Tuser.clear();
    Tpass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    top: 0, bottom: MediaQuery.of(context).size.width / 13),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'images/bg.png',
                  ),
                  fit: BoxFit.fill,
                )),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset('images/clgicon.png'),
                        ],
                      ),
                      Text(
                        ' LOGIN ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          letterSpacing: 4,
                          fontSize: MediaQuery.of(context).size.width / 10.5,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal:
                                  MediaQuery.of(context).size.width / 12),
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width / 30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(140, 158, 251, 1),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      focusNode: _rnumFocusNode,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_passFocusNode);
                                      },
                                      controller: Tuser,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Rollno",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          icon: Icon(
                                            Icons.email,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0.0),
                                    child: TextField(
                                      focusNode: _passFocusNode,
                                      onSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(null);
                                      },
                                      textInputAction: TextInputAction.done,
                                      controller: Tpass,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          icon: Icon(Icons.lock,
                                              color: Colors.black)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 12,
                            ),
                            Text(
                              errMsg,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 20,
                            ),
                            InkWell(
                              onTap: () async {
                                firebaseCloudMessaging();
                                errMsg = '';

                                var i = 0;

                                setState(() {
                                  if (Tuser.text.isEmpty) {
                                    errMsg = 'Roll number should not be empty';
                                    i = 1;
                                  }
                                  if (Tpass.text.isEmpty) {
                                    errMsg = 'Password should not be empty';
                                    i = 1;
                                  }
                                  if (Tuser.text.isEmpty &&
                                      Tpass.text.isEmpty) {
                                    errMsg = 'Both fields are empty';
                                    i = 1;
                                  }
                                });
                                if (i == 0) {
                                  await getIStatus();
                                  if (Istatus) {
                                    await userLogin();
                                  } else
                                    Fluttertoast.showToast(
                                        msg: 'No Internet Connection',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                }
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width / 10.5,
                                width: MediaQuery.of(context).size.width / 2.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width / 10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF3383CD),
                                      Color(0xFF3383CD),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 20,
                            ),
                            InkWell(
                              onTap: () {
                                getIStatus();
                                if (Istatus) {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute<bool>(
                                          fullscreenDialog: false,
                                          builder: (BuildContext context) =>
                                              ForgotSelect()));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No Internet Connection',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
