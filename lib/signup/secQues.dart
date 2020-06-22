import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared.dart';
import '../loading.dart';
import '../onboarding/clgImageScreen.dart';

class SecQues extends StatefulWidget {
  @override
  _SecQuesState createState() => _SecQuesState();
}

class _SecQuesState extends State<SecQues> {
  String currentSelectQuestion1;
  String currentSelectQuestion2;
  bool _validateQ = false;
  bool _validateIQ1 = false;
  bool loading = false;
  bool _validateIQ2 = false;
  bool _validateIA1 = false;
  bool _validateIA2 = false;
  String q1, q2;
  String errMsgQ1 = '';
  String errMsgQ2 = '';

  TextEditingController ta1 = TextEditingController();
  TextEditingController ta2 = TextEditingController();

  String studentName,
      studentDOB,
      studentEMail,
      studentMobno,
      studentAddress,
      studentBG,
      guardianName,
      guardianAddress,
      guardianRelationship,
      guardianMobno,
      regno,
      rollno,
      batch,
      branch,
      hRoomno,
      hName,
      hJoiningData,
      sQ1,
      sQ2,
      sA1,
      sA2;

  bool Istatus;
  String gender;

  getIStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Istatus = true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      Istatus = true;
    } else {
      Istatus = false;
    }
  }

  var time;
  String sessionToken, toastText;
  var status;

  Future userRegistration() async {
    await Firestore.instance
        .collection('$batch/$branch/Profile')
        .document(rollno)
        .setData({
      'sName': studentName,
      'sGender': gender,
      'sDOB': studentDOB,
      'sBG': studentBG,
      'sMail': studentEMail,
      'sMobNum': studentMobno,
      'sAddress': studentAddress,
      'gName': guardianName,
      'gMobNum': guardianMobno,
      'gRelation': guardianRelationship,
      'gAddress': guardianAddress,
      'regNum': regno,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
      'hRoomNum': hRoomno,
      'hName': hName,
      'hJoinDate': hJoiningData,
      'sQues1': sQ1,
      'sQues2': sQ2,
      'sAns1': sA1,
      'sAns2': sA2,
      'time': time.toString(),
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PaymentHistory')
        .document('JAN')
        .setData({
      'month': 'JAN',
      'year': '2017',
      'paidDate': '22-02-2017',
      'amount': '2700',
      'numDSH': '25',
      'amPDay': '60',
      'billDate': '15-01-2017',
      'dueDate': '28-02-2017',
      'txnId': '1359021',
      'txnRef': '1359021',
      'time': '4:47 PM',
      'payBy': 'Google Pay',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PaymentHistory')
        .document('FEB')
        .setData({
      'month': 'FEB',
      'year': '2017',
      'paidDate': '22-03-2017',
      'amount': '2800',
      'numDSH': '28',
      'amPDay': '62',
      'billDate': '15-02-2017',
      'dueDate': '28-03-2017',
      'txnId': '135902789',
      'txnRef': '135909021',
      'time': '4:97 PM',
      'payBy': 'Airtel UPI Pay',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PaymentHistory')
        .document('MAR')
        .setData({
      'month': 'MAR',
      'year': '2017',
      'paidDate': '22-03-2017',
      'amount': '2300',
      'numDSH': '20',
      'amPDay': '55',
      'billDate': '15-03-2017',
      'dueDate': '28-04-2017',
      'txnId': '135909021',
      'txnRef': '139859021',
      'time': '2:47 AM',
      'payBy': 'Amazon Pay',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PaymentHistory')
        .document('APR')
        .setData({
      'month': 'APR',
      'year': '2017',
      'paidDate': '22-04-2017',
      'amount': '2100',
      'numDSH': '20',
      'amPDay': '50',
      'billDate': '15-04-2017',
      'dueDate': '28-05-2017',
      'txnId': '1358998989021',
      'txnRef': '135089021',
      'time': '1:47 PM',
      'payBy': 'BHIM UPI Pay',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });

    await Firestore.instance
        .document(
            'Login/${rollno.substring(0, 2)}/${rollno.substring(2, 4)}/$rollno')
        .setData({
      'batch': batch,
      'branch': branch,
      'pass': studentMobno,
      'user': rollno,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PendingDues')
        .document('OCT')
        .setData({
      'month': 'OCT',
      'year': '2017',
      'amount': '2100',
      'numDSH': '24',
      'amPDay': '53',
      'billDate': '15-10-2017',
      'dueDate': '24-11-2017',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PendingDues')
        .document('NOV')
        .setData({
      'month': 'NOV',
      'year': '2017',
      'amount': '2050',
      'numDSH': '20',
      'amPDay': '60',
      'billDate': '10-11-2017',
      'dueDate': '20-12-2017',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    await Firestore.instance
        .collection('$batch/$branch/PaymentDetails')
        .document(rollno)
        .collection('PendingDues')
        .document('DEC')
        .setData({
      'month': 'DEC',
      'year': '2017',
      'amount': '2150',
      'numDSH': '28',
      'amPDay': '68',
      'billDate': '06-12-2017',
      'dueDate': '22-01-2018',
      'sName': studentName,
      'rollNum': rollno,
      'batch': batch,
      'branch': branch,
    });
    DocumentReference documentReference =
        Firestore.instance.document('2017/$branch/Profile/$rollno');
    documentReference.snapshots().listen((event) {
      if (event.exists)
        status = 'Your details stored successfulyy';
      else
        status = 'Your details are not stored. Try again.';
    });
  }

  @override
  void dispose() {
    ta1.dispose();
    ta2.dispose();
    super.dispose();
  }

  @override
  Widget selectQuestion1() {
    return InputDecorator(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width / 23),
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        hint: Text(
          'Select Your Question',
          style: TextStyle(color: Colors.white),
        ),
        value: currentSelectQuestion1,
        isDense: true,
        onChanged: (String newValue) {
          setState(() {
            currentSelectQuestion1 = newValue;
            q1 = currentSelectQuestion1;
            _validateQ = false;
          });
        },
        items: <String>[
          'What is your pet\'s name ?',
          'What is your favorite animal ?',
          'What is your favorite movie ?',
          'What is your favorite color ?',
          'What is your phone number ?',
          'In what city were you born ?',
          'What is your favorite sport ?'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )),
    );
  }

  Widget selectQuestion2() {
    return InputDecorator(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width / 23),
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        hint: Text(
          'Select Your Question',
          style: TextStyle(color: Colors.white),
        ),
        value: currentSelectQuestion2,
        isDense: true,
        onChanged: (String newValue) {
          setState(() {
            currentSelectQuestion2 = newValue;
            q2 = currentSelectQuestion2;
            _validateQ = false;
          });
        },
        items: <String>[
          'What is your pet\'s name ?',
          'What is your favorite animal ?',
          'What is your favorite movie ?',
          'What is your favorite color ?',
          'What is your phone number ?',
          'In what city were you born ?',
          'What is your favorite sport ?'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )),
    );
  }

  Widget inputBox(String label, String errMsg, int i, bool validate,
      TextEditingController c, TextInputType t, Icon icon) {
    return TextFormField(
      controller: c,
      keyboardType: t,
      autofocus: false,
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
        if (i == 1) {
          _validateIQ1 = false;
        }
        if (i == 2) {
          _validateIQ2 = false;
        }
      },
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : new Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width / 20, vertical: 0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'images/bg.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset('images/clgicon.png',
                              height: MediaQuery.of(context).size.width / 2.4),
                        ],
                      ),
                      Text(
                        'Security Question',
                        textAlign: TextAlign.center,
                        style: titleTextStyle.copyWith(
                            fontSize: size.width / 13,
                            letterSpacing: 1.5,
                            color: Colors.white),
                      ),
                      selectQuestion1(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          errMsgQ1,
                          style: TextStyle(color: Colors.red, fontSize: 13.5),
                        ),
                      ),
                      inputBox(
                        'Answer',
                        'Must give Answer',
                        1,
                        _validateIA1,
                        ta1,
                        TextInputType.text,
                        Icon(Icons.question_answer,
                            size: 28, color: Colors.white),
                      ),
                      SizedBox(
                        height: size.width / 20,
                      ),
                      selectQuestion2(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          errMsgQ2,
                          style: TextStyle(color: Colors.red, fontSize: 13.5),
                        ),
                      ),
                      inputBox(
                          'Answer',
                          'Must give Answer',
                          2,
                          _validateIA2,
                          ta2,
                          TextInputType.text,
                          Icon(Icons.question_answer,
                              size: 28, color: Colors.white)),
                      SizedBox(
                        height: size.width / 30,
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
                              time = await DateTime.now();
                              SharedPreferences signupPrefs =
                                  await SharedPreferences.getInstance();
                              studentName = signupPrefs.getString('sName');
                              studentDOB = signupPrefs.getString('sDOB');
                              gender = signupPrefs.getString('sGender');
                              studentEMail = signupPrefs.getString('sMail');
                              studentMobno = signupPrefs.getString('sMobNum');
                              studentAddress =
                                  signupPrefs.getString('sAddress');
                              studentBG = signupPrefs.getString('sBG');
                              guardianName = signupPrefs.getString('gName');
                              guardianAddress =
                                  signupPrefs.getString('gAddress');
                              guardianRelationship =
                                  signupPrefs.getString('gRelation');
                              guardianMobno = signupPrefs.getString('gMobNum');
                              regno = signupPrefs.getString('regNum');
                              rollno = signupPrefs.getString('rollNum');
                              batch = signupPrefs.getString('batch');
                              branch = signupPrefs.getString('branch');
                              hRoomno = signupPrefs.getString('hRoomNum');
                              hName = signupPrefs.getString('hName');
                              hJoiningData = signupPrefs.getString('hJoinDate');

                              var i = 0;
                              setState(() {
                                _validateIA1 = false;
                                _validateIA2 = false;
                                errMsgQ1 = '';
                                errMsgQ2 = '';

                                if (ta1.text.isEmpty) {
                                  _validateIA1 = true;
                                  i = 1;
                                }
                                if (ta2.text.isEmpty) {
                                  _validateIA2 = true;
                                  i = 1;
                                }
                                if (currentSelectQuestion1 == null) {
                                  setState(() {
                                    errMsgQ1 = 'Must select question';
                                  });

                                  i = 1;
                                }
                                if (currentSelectQuestion1 ==
                                    currentSelectQuestion2) {
                                  errMsgQ1 = 'Two questions are same';
                                  errMsgQ2 = 'Two questions are same';
                                  i = 1;
                                }

                                if (currentSelectQuestion2 == null) {
                                  errMsgQ2 = 'Must select question';
                                  i = 1;
                                }
                              });
                              if (i == 0) {
                                await getIStatus();
                                if (Istatus) {
                                  signupPrefs.setString('sQues1', q1);
                                  signupPrefs.setString('sQues2', q2);
                                  signupPrefs.setString('sAns1', ta1.text);
                                  signupPrefs.setString('sAns2', ta2.text);
                                  sQ1 = signupPrefs.getString('sQues1');
                                  sQ2 = signupPrefs.getString('sQues2');
                                  sA1 = signupPrefs.getString('sAns1');
                                  sA2 = signupPrefs.getString('sAns2');

                                  if (studentName != null &&
                                      studentDOB != null &&
                                      studentEMail != null &&
                                      studentMobno != null &&
                                      studentAddress != null &&
                                      studentBG != null &&
                                      guardianName != null &&
                                      guardianAddress != null &&
                                      guardianRelationship != null &&
                                      guardianMobno != null &&
                                      regno != null &&
                                      rollno != null &&
                                      batch != null &&
                                      branch != null &&
                                      hRoomno != null &&
                                      hName != null &&
                                      sQ1 != null &&
                                      sQ2 != null &&
                                      sA1 != null &&
                                      sA2 != null &&
                                      hJoiningData != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    userRegistration().whenComplete(() {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.of(context, rootNavigator: true)
                                          .push(CupertinoPageRoute<bool>(
                                              fullscreenDialog: false,
                                              builder: (BuildContext context) =>
                                                  StaticScreen()));
                                    });
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'No Internet Connection',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
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
