import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared.dart';
import '../signup/collegeInfo.dart';

class GuardianDet extends StatefulWidget {
  @override
  _GuardianDetState createState() => _GuardianDetState();
}

class _GuardianDetState extends State<GuardianDet> {
  bool _validateGN = false;
  bool _validateGM = false;
  bool _validateGAD = false;
  bool _validateGR = false;
  String grelation;
  String errMsgGrelation = '';
  var currentSelectvalue;
  final _gnameFn = FocusNode();
  final _gmobNumFn = FocusNode();
  final _grelFn = FocusNode();
  final _gaddrFn = FocusNode();
  TextEditingController Tgname = TextEditingController();
  TextEditingController Tgmobnum = TextEditingController();
  TextEditingController Tgaddress = TextEditingController();

  @override
  void dispose() {
    Tgmobnum.dispose();
    Tgname.dispose();
    Tgaddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget selectGuardianRelation(FocusNode node) {
      return InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 25),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: Text(
            'Select Your Relationship',
            style: TextStyle(color: Colors.white),
          ),
          focusNode: node,
          value: currentSelectvalue,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              currentSelectvalue = newValue;
              grelation = currentSelectvalue;
              _validateGR = false;
            });
          },
          items: <String>['Father', 'Mother', 'relative', 'others']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
      );
    }

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
        textInputAction: action,
        focusNode: cnode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(node);
        },
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
        maxLines: i == 5 ? 2 : 1,
        showCursor: true,
        autocorrect: true,
        onChanged: (value) {
          if (i == 1) {
            _validateGN = false;
          }
          if (i == 4) {
            _validateGM = false;
          }

          if (i == 5) {
            _validateGAD = false;
          }
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding:
                EdgeInsets.symmetric(horizontal: size.width / 20, vertical: 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
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
                    'Guardian Info',
                    style: titleTextStyle.copyWith(
                        fontSize: size.width / 12,
                        letterSpacing: 1.5,
                        color: Colors.white),
                  ),
                  inputBox(
                    'Guardian Name',
                    'Name must contains Alphabets',
                    1,
                    _validateGN,
                    TextInputType.text,
                    Icon(Icons.person, size: 28, color: Colors.white),
                    Tgname,
                    TextInputAction.next,
                    _gnameFn,
                    _gmobNumFn,
                  ),
                  inputBox(
                    'Guardian Mobile Number',
                    'Mobile number must containe 10 digits',
                    4,
                    _validateGM,
                    TextInputType.phone,
                    Icon(Icons.call, size: 28, color: Colors.white),
                    Tgmobnum,
                    TextInputAction.next,
                    _gmobNumFn,
                    _grelFn,
                  ),
                  selectGuardianRelation(_grelFn),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      errMsgGrelation,
                      style: TextStyle(color: Colors.red, fontSize: 11.5),
                    ),
                  ),
                  inputBox(
                    'Guardian Home Address',
                    'Address must contains atleast 10 characters',
                    5,
                    _validateGAD,
                    TextInputType.multiline,
                    Icon(Icons.home, size: 28, color: Colors.white),
                    Tgaddress,
                    TextInputAction.newline,
                    _gaddrFn,
                    null,
                  ),
                  Row(
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
                            errMsgGrelation = '';
                            var i = 0;
                            final validCharacters = RegExp(r'^[a-zA-Z \.]+$');
                            if (Tgname.text.isEmpty ||
                                !validCharacters.hasMatch(Tgname.text)) {
                              _validateGN = true;
                              i = 1;
                            }
                            if (Tgmobnum.text.isEmpty ||
                                Tgmobnum.text.length != 10 ||
                                Tgmobnum.text.contains(' ') ||
                                Tgmobnum.text.contains(',') ||
                                Tgmobnum.text.contains('.')) {
                              _validateGM = true;
                              i = 1;
                            }
                            if (Tgaddress.text.isEmpty ||
                                Tgaddress.text.length < 10) {
                              _validateGAD = true;
                              i = 1;
                            }

                            if (currentSelectvalue == null) {
                              i = 1;
                              errMsgGrelation = 'Must select any one type';
                            }
                            if (i == 0) {
                              signupPrefs.setString('gName', Tgname.text);
                              signupPrefs.setString('gMobNum', Tgmobnum.text);
                              signupPrefs.setString('gAddress', Tgaddress.text);
                              signupPrefs.setString('gRelation', grelation);
                              Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          CollegeDet()));
                            }
                          });
                        },
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 28)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
