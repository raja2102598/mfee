import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './onboarding/clgImageScreen.dart';
import 'package:validators/validators.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import './shared.dart';
import './loading.dart';

class ForgotPass extends StatefulWidget {
  String q1, q2, a1, a2, year, branch, roll;

  ForgotPass(
      this.q1, this.q2, this.a1, this.a2, this.year, this.branch, this.roll);

  @override
  _ForgotPassState createState() => _ForgotPassState(
      this.q1, this.q2, this.a1, this.a2, this.year, this.branch, this.roll);
}

String question1, question2;

class _ForgotPassState extends State<ForgotPass> {
  String dq1, dq2, da1, da2, year, branch, roll;

  _ForgotPassState(this.dq1, this.dq2, this.da1, this.da2, this.year,
      this.branch, this.roll);

  bool _validateQ = false;
  bool _validateIQ1 = false;
  bool loading = false;
  bool _validateIQ2 = false;
  bool _validateIA1 = false;
  bool _validateIA2 = false;
  bool _validateIP = false;
  String errMsgQ1 = '';
  String errMsgQ2 = '';
  String password;
  String a1, a2;
  String sessionToken, toastText;

  Future evaluation() async {
    initializeDateFormatting();
    DateTime now = DateTime.now();
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res =
        DateFormat("dd-MM-yyyy").format(now) + "  " + timeOfDay.format(context);
    Firestore.instance
        .document('Login/${roll.substring(0, 2)}/${roll.substring(2, 4)}/$roll')
        .updateData({
      'lastPasswordChange': res,
      'pass': password,
    });
    Fluttertoast.showToast(
        msg: 'Your password has been updated',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context, rootNavigator: true).pushReplacement(
        CupertinoPageRoute<bool>(
            fullscreenDialog: false,
            builder: (BuildContext context) => UIscreen1()));
  }

  Widget inputBox(
    String label,
    String errMsg,
    int i,
    bool validate,
    TextInputType t,
    Icon icon,
  ) {
    return TextFormField(
      keyboardType: t,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 0, vertical: MediaQuery.of(context).size.width / 24),
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
      showCursor: true,
      autocorrect: true,
      onChanged: (value) {
        if (i == 1) {
          _validateIQ1 = false;
          a1 = value;
        }
        if (i == 2) {
          _validateIQ2 = false;
          a2 = value;
        }

        if (i == 3) {
          _validateIP = false;
          password = value;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    question1 = dq1;
    question2 = dq2;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  ),
                ),
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
                        'Forgot Password',
                        style:
                            titleTextStyle.copyWith(fontSize: size.width / 15),
                      ),
                      SizedBox(
                        height: size.width / 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: MediaQuery.of(context).size.width / 12),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 7.5,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                question1,
                                style: TextStyle(
                                  fontSize: size.width / 23,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 80,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                errMsgQ1,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 13.5),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 80,
                            ),
                            inputBox(
                              'Answer',
                              'Must give Answer',
                              1,
                              _validateIA1,
                              TextInputType.text,
                              Icon(Icons.question_answer,
                                  size: 28, color: Colors.white),
                            ),
                            SizedBox(
                              height: size.width / 18,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 7.5,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                question2,
                                style: TextStyle(
                                  fontSize: size.width / 23,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 80,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                errMsgQ2,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 13.5),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 80,
                            ),
                            inputBox(
                                'Answer',
                                'Must give Answer',
                                2,
                                _validateIA2,
                                TextInputType.text,
                                Icon(Icons.question_answer,
                                    size: 28, color: Colors.white)),
                            SizedBox(
                              height: size.width / 13,
                            ),
                            inputBox(
                                'Password',
                                'Must give Password',
                                3,
                                _validateIP,
                                TextInputType.visiblePassword,
                                Icon(Icons.person,
                                    size: 28, color: Colors.white)),
                            SizedBox(
                              height: size.width / 50,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _validateIA1 = false;
                            _validateIA2 = false;
                            _validateIP = false;
                            errMsgQ1 = '';
                            errMsgQ2 = '';
                            var i = 0;
                            if (a1 == null) {
                              _validateIA1 = true;
                              i = 1;
                            }

                            if (a2 == null) {
                              _validateIA2 = true;
                              i = 1;
                            }
                            if (password == null) {
                              _validateIP = true;
                              i = 1;
                            }
                            if (i == 0) {
                              print(da2);
                              if (a1 == da1 && a2 == da2) {
                                evaluation();
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Data Invalid',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 10,
                          width: MediaQuery.of(context).size.width / 1.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width / 10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.blue,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class ForgotSelect extends StatefulWidget {
  @override
  _ForgotSelectState createState() => _ForgotSelectState();
}

class _ForgotSelectState extends State<ForgotSelect> {
  final _rnumFocusNode = FocusNode();
  final _batchFocusNode = FocusNode();
  final _branchFocusNode = FocusNode();

  bool _validateRoll = false;
  bool _validateBatch = false;
  bool _validateBranch = false;
  String errMsgBatch = '';
  String errMsgBranch = '';
  var currentSelectvalueBatch;
  var currentSelectvalueBranch;
  bool loadingW = false;

  TextEditingController TrollNum = TextEditingController();

  @override
  void dispose() {
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
        )),
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
        FocusNode node,
        FocusNode cnode) {
      return TextFormField(
        keyboardType: t,
        controller: c,
        autofocus: true,
        textInputAction: action,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(node);
        },
        focusNode: cnode,
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
        showCursor: true,
        autocorrect: true,
        onChanged: (value) {
          if (i == 4) {
            _validateRoll = false;
          }
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    return loadingW
        ? Loading()
        : new Scaffold(
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
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / 20, vertical: 0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset('images/clgicon.png'),
                        ],
                      ),
                      Text(
                        'Forgot Password',
                        style: titleTextStyle.copyWith(
                            fontSize: size.width / 12,
                            letterSpacing: 1.5,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: size.width / 60,
                      ),
                      Column(
                        children: <Widget>[
                          inputBox(
                            'Your Roll Number',
                            'Invalid Roll Number',
                            4,
                            _validateRoll,
                            TextInputType.text,
                            Icon(Icons.account_balance,
                                size: 28, color: Colors.white),
                            TrollNum,
                            TextInputAction.next,
                            _batchFocusNode,
                            _rnumFocusNode,
                          ),
                          SizedBox(
                            height: size.width / 15,
                          ),
                          selectBatch(_batchFocusNode),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              errMsgBatch,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 13.5),
                            ),
                          ),
                          SizedBox(
                            height: size.width / 15,
                          ),
                          selectBranch(_branchFocusNode),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              errMsgBranch,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text('NEXT',
                                style: btnstyle.copyWith(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                )),
                            onPressed: () async {
                              var i = 0;
                              var sum = 0;
                              setState(() {
                                errMsgBatch = '';
                                errMsgBranch = '';

                                for (var i = 0; i < TrollNum.text.length; i++) {
                                  if (isAlpha(TrollNum.text[i])) sum = sum + 1;
                                }
                                var check = 0;
                                for (var i = 0; i < TrollNum.text.length; i++) {
                                  if (i != 2 && i != 3) {
                                    if (isAlpha(TrollNum.text[i]))
                                      check = check + 1;
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
                              });
                              if (i == 0) {
                                var q1, q2, a1, a2;
                                TrollNum.text = TrollNum.text.toUpperCase();
                                setState(() {
                                  loadingW = true;
                                });
                                await Firestore.instance
                                    .document(
                                        '$currentSelectvalueBatch/$currentSelectvalueBranch/Profile/${TrollNum.text}')
                                    .get()
                                    .then((value) {
                                  if (value.exists) {
                                    q1 = value['sQues1'];
                                    q2 = value['sQues2'];
                                    a1 = value['sAns1'];
                                    a2 = value['sAns2'];
                                  } else {
                                    setState(() {
                                      loadingW = false;
                                    });
                                  }
                                });
                                setState(() {
                                  loadingW = false;
                                });
                                if (q1 == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Data Invalid',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute<bool>(
                                          fullscreenDialog: false,
                                          builder: (BuildContext context) =>
                                              ForgotPass(
                                                  q1,
                                                  q2,
                                                  a1,
                                                  a2,
                                                  currentSelectvalueBatch,
                                                  currentSelectvalueBranch,
                                                  TrollNum.text)));
                                }
                              }
                            },
                          ),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 28)
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
