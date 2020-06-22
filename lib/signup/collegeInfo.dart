import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import '../shared.dart';
import '../signup/hostelInfo.dart';

class CollegeDet extends StatefulWidget {
  @override
  _CollegeDetState createState() => _CollegeDetState();
}

class _CollegeDetState extends State<CollegeDet> {
  bool _validateReg = false;
  bool _validateRoll = false;
  bool _validateBatch = false;
  bool _validateBranch = false;
  String errMsgBatch = '';
  String errMsgBranch = '';
  var currentSelectvalueBatch;
  var currentSelectvalueBranch;

  final _regnoFn = FocusNode();
  final _rollnumFn = FocusNode();
  final _batchFn = FocusNode();
  final _branchFn = FocusNode();
  TextEditingController TregNum = TextEditingController();
  TextEditingController TrollNum = TextEditingController();

  @override
  void dispose() {
    TregNum.dispose();
    TrollNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget selectBatch(FocusNode node) {
      return InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 25),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              'Select Your Batch',
              style: TextStyle(color: Colors.white),
            ),
            focusNode: node,
            value: currentSelectvalueBatch,
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                currentSelectvalueBatch = newValue;
                _validateBatch = false;
              });
            },
            items: <String>[
              '2016 - 2020',
              '2017 - 2021',
              '2018 - 2022',
              '2019 - 2023',
              '2020 - 2024',
              '2021 - 2025'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget selectBranch(FocusNode node) {
      return InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 25),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: Text(
            'Select Your Branch',
            style: TextStyle(color: Colors.white),
          ),
          focusNode: node,
          value: currentSelectvalueBranch,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              currentSelectvalueBranch = newValue;
              _validateBranch = false;
            });
          },
          items: <String>['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL']
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
        keyboardType: t,
        controller: c,
        autofocus: false,
        textInputAction: action,
        focusNode: cnode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(node);
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: MediaQuery.of(context).size.width / 20),
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
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        cursorColor: Colors.white,
        showCursor: true,
        autocorrect: true,
        onChanged: (value) {
          if (i == 1) {
            _validateReg = false;
          }
          if (i == 4) {
            _validateRoll = false;
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
              fit: BoxFit.cover,
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
                    //Text('sak'),
                    Image.asset('images/clgicon.png',
                        height: MediaQuery.of(context).size.width / 2.4),
                  ],
                ),
                Text(
                  'College Info',
                  style: titleTextStyle.copyWith(
                      fontSize: size.width / 12,
                      letterSpacing: 1.5,
                      color: Colors.white),
                ),
                SizedBox(
                  height: size.width / 60,
                ),
                inputBox(
                  'Your Register Number',
                  'Register number must be 12',
                  1,
                  _validateReg,
                  TextInputType.number,
                  Icon(Icons.account_balance, size: 28, color: Colors.white),
                  TregNum,
                  TextInputAction.next,
                  _regnoFn,
                  _rollnumFn,
                ),
                SizedBox(
                  height: size.width / 100,
                ),
                inputBox(
                  'Your Roll Number',
                  'Invalid Roll Number',
                  4,
                  _validateRoll,
                  TextInputType.text,
                  Icon(Icons.account_balance, size: 28, color: Colors.white),
                  TrollNum,
                  TextInputAction.next,
                  _rollnumFn,
                  _batchFn,
                ),
                SizedBox(
                  height: size.width / 100,
                ),
                selectBatch(_batchFn),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      errMsgBatch,
                      style: TextStyle(color: Colors.red, fontSize: 13.5),
                    )),
                selectBranch(_branchFn),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      errMsgBranch,
                      style: TextStyle(color: Colors.red, fontSize: 13.5),
                    )),
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
                          errMsgBatch = '';
                          errMsgBranch = '';
                          var i = 0;

                          if (TregNum.text.isEmpty ||
                              TregNum.text.length != 12 ||
                              TregNum.text.contains(' ') ||
                              TregNum.text.contains(',') ||
                              TregNum.text.contains('.')) {
                            _validateReg = true;
                            i = 1;
                          }
                          var sum = 0;
                          for (var i = 0; i < TrollNum.text.length; i++) {
                            if (isAlpha(TrollNum.text[i])) sum = sum + 1;
                          }
                          var check = 0;
                          for (var i = 0; i < TrollNum.text.length; i++) {
                            if (i != 2 && i != 3) {
                              if (isAlpha(TrollNum.text[i])) check = check + 1;
                            }
                          }
                          if (TrollNum.text.isEmpty ||
                              !isAlphanumeric(TrollNum.text) ||
                              TrollNum.text.length != 6 ||
                              TrollNum.text.contains(' ') ||
                              TrollNum.text.contains(',') ||
                              TrollNum.text.contains('.')) {
                            _validateRoll = true;
                            i = 1;
                          }
                          if (sum != 2) {
                            _validateRoll = true;
                            i = 1;
                          }
                          if (check > 0) {
                            _validateRoll = true;
                            i = 1;
                          }

                          if (currentSelectvalueBatch == null) {
                            i = 1;
                            errMsgBatch = 'Must select any one Batch';
                          }
                          if (currentSelectvalueBranch == null) {
                            i = 1;
                            errMsgBranch = 'Must select any one Branch';
                          }
                          if (i == 0) {
                            TrollNum.text = TrollNum.text.toUpperCase();
                            signupPrefs.setString('rollNum', TrollNum.text);
                            signupPrefs.setString('regNum', TregNum.text);
                            signupPrefs.setString(
                                'batch', currentSelectvalueBatch);
                            signupPrefs.setString(
                                'branch', currentSelectvalueBranch);

                            Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                    fullscreenDialog: false,
                                    builder: (BuildContext context) =>
                                        HostelDet()));
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
    );
  }
}
