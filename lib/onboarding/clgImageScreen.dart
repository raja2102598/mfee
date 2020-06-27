import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login.dart';
import '../shared.dart';
import '../signup/personalDetails.dart';

class UIscreen1 extends StatefulWidget {
  _UIscreen1 createState() => _UIscreen1();
}

class _UIscreen1 extends State<UIscreen1> {
  final _style = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  final _subStyle = TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.italic,
    fontFamily: 'Poppins',
  );

  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              elevation: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                'Are you sure?',
                style: titleTextStyle.copyWith(color: pridarkColor),
              ),
              content: Text('Do you want to exit an App',
                  style: subtitleTextStyle.copyWith(color: pridarkColor)),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: new GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Text(
                      "NO",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, right: 20),
                  child: new GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Text("YES"),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/clgicon.png',
                        height: MediaQuery.of(context).size.width / 2.4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width / 80.0),
                Container(
                  alignment: Alignment.topCenter,
                  child: Image(
                    image: AssetImage(
                      'images/clg.jpeg',
                    ),
                    width: size.width,
                    height: size.height / 4,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                    child: Column(
                  children: <Widget>[
                    SizedBox(height: size.width / 30.0),
                    Text(
                      'Gcetj mfee'.toUpperCase(),
                      style: _style.copyWith(
                        fontSize: size.width / 13,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.width / 20.0),
                    Text(
                      'Goverment College Of '.toUpperCase(),
                      style: _style.copyWith(
                        fontSize: size.width / 17,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Engineering - Thanjavur'.toUpperCase(),
                      style: _style.copyWith(
                        letterSpacing: 1,
                        fontSize: size.width / 17,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.width / 80.0),
                    Text(
                      'Land of Knowledge',
                      style: _subStyle.copyWith(
                        fontSize: size.width / 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
                SizedBox(height: size.width / 30),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: size.width / 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        height: size.width / 10,
                        width: size.width / 3.5,
                        child: FlatButton(
                          child: Text(
                            'SIGNUP',
                            style: _style.copyWith(
                                fontSize: size.width / 20, color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          SignUP()));
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: size.width / 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        height: size.width / 10,
                        width: size.width / 3.5,
                        child: FlatButton(
                          child: Text(
                            'LOGIN',
                            style: _style.copyWith(
                                fontSize: size.width / 20, color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          LoginPage()));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width / 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StaticScreen extends StatefulWidget {
  @override
  _StaticScreenState createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => UIscreen1()),
            (Route<dynamic> route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: pridarkColor,
          title: Row(
            children: <Widget>[
              Text(
                'Back',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20, vertical: 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/bg.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              'Thank You for Registering your Details. Go back and Login.',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class NoSignUp extends StatefulWidget {
  @override
  _NoSignUpState createState() => _NoSignUpState();
}

class _NoSignUpState extends State<NoSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Back',
          style: subtitleTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.width / 19,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              fontFamily: "CM Sans Serif"),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'You are already registered. If you give false details in registration uninstall this app and install once again or contact Office. ',
            style: TextStyle(color: Colors.black, fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
