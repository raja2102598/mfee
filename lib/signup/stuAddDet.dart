import 'dart:core';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared.dart';
import '../signup/guardianInfo.dart';

class SignUPAdd extends StatefulWidget {
  @override
  _SignUPAddState createState() => _SignUPAddState();
}

class _SignUPAddState extends State<SignUPAdd> {
  bool _validateE = false;
  bool _validateM = false;
  bool _validateAD = false;

  TextEditingController Tmail = TextEditingController();
  TextEditingController Tmobno = TextEditingController();
  TextEditingController Taddress = TextEditingController();

  final _emailFn = FocusNode();
  final _mobNumFn = FocusNode();
  final _addFn = FocusNode();
  @override
  void dispose() {
    Tmail.dispose();
    Tmobno.dispose();
    Taddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputBox(
      String label,
      String errMsg,
      int i,
      bool validate,
      TextInputType t,
      Icon icon,
      TextEditingController c,
      TextInputAction action,
      FocusNode cnode,
      FocusNode node,
    ) {
      return TextFormField(
        controller: c,
        keyboardType: t,
        autofocus: false,
        focusNode: cnode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(node);
        },
        textInputAction: action,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: MediaQuery.of(context).size.width / 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorText: validate ? errMsg : null,
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: icon,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        cursorColor: Colors.white,
        maxLines: i == 5 ? 3 : 1,
        showCursor: true,
        autocorrect: true,
        onChanged: (value) {
          if (i == 3) {
            _validateE = false;
          }
          if (i == 4) {
            _validateM = false;
          }

          if (i == 5) {
            _validateAD = false;
          }
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/bg.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          padding:
              EdgeInsets.symmetric(horizontal: size.width / 20, vertical: 0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('images/clgicon.png',
                        height: MediaQuery.of(context).size.width / 2.4),
                  ],
                ),
                Text(
                  'Address Info',
                  style: titleTextStyle.copyWith(
                      fontSize: size.width / 12,
                      letterSpacing: 1.5,
                      color: Colors.white),
                ),
                inputBox(
                  'Your Mail ID',
                  'Invalid Mail id',
                  3,
                  _validateE,
                  TextInputType.emailAddress,
                  Icon(Icons.email, size: 28, color: Colors.white),
                  Tmail,
                  TextInputAction.next,
                  _emailFn,
                  _mobNumFn,
                ),
                inputBox(
                  'Your Mobile Number',
                  'Mobile number must contains 10 digits',
                  4,
                  _validateM,
                  TextInputType.phone,
                  Icon(Icons.call, size: 28, color: Colors.white),
                  Tmobno,
                  TextInputAction.next,
                  _mobNumFn,
                  _addFn,
                ),
                inputBox(
                  'Your Home Address',
                  'Address must contains atleast 10 characters',
                  5,
                  _validateAD,
                  TextInputType.multiline,
                  Icon(Icons.home, size: 28, color: Colors.white),
                  Taddress,
                  TextInputAction.done,
                  _addFn,
                  null,
                ),
                SizedBox(
                  height: size.width / 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('NEXT',
                            style: btnstyle.copyWith(
                              fontSize: MediaQuery.of(context).size.width / 18,
                            )),
                        onPressed: () async {
                          SharedPreferences signupPrefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            var i = 0;
                            if (Tmail.text.isEmpty ||
                                !EmailValidator.validate(Tmail.text)) {
                              _validateE = true;
                              i = 1;
                            }
                            if (Tmobno.text.isEmpty ||
                                Tmobno.text.length != 10 ||
                                Tmobno.text.contains(' ') ||
                                Tmobno.text.contains(',') ||
                                Tmobno.text.contains('.')) {
                              _validateM = true;
                              i = 1;
                            }
                            if (Taddress.text.isEmpty ||
                                Taddress.text.length < 10) {
                              _validateAD = true;
                              i = 1;
                            }

                            if (i == 0) {
                              signupPrefs.setString('sMail', Tmail.text);
                              signupPrefs.setString('sMobNum', Tmobno.text);
                              signupPrefs.setString(
                                  'sAddress', Taddress.text.trim());

                              Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          GuardianDet()));
                            }
                          });
                        },
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 28)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
