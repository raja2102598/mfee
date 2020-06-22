import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import './shared.dart';
import './main.dart';

class MFeeQueries extends StatefulWidget {
  @override
  _MFeeQueriesState createState() => _MFeeQueriesState();
}

class _MFeeQueriesState extends State<MFeeQueries> {
  final _seleIssueNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _issueFocusNode = FocusNode();

  final _submitFocusNode = FocusNode();
  bool _load = false;
  String errMsgM = '';
  String errMsgIs = '';
  bool _validateIT = false;
  bool _validateIs = false;
  String currentSelectvalue;
  bool validateM = false;
  TextEditingController issue = TextEditingController();
  TextEditingController mail = TextEditingController();
  String loadText = '';
  DateTime time;
  String errMsgIT = '';
  var iStatus = false;

  getIStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      iStatus = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iStatus = true;
    } else {
      iStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future sendQueries() async {
      initializeDateFormatting();
      DateTime now = DateTime.now();
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
      String res = DateFormat("dd-MM-yyyy").format(now) +
          "  " +
          timeOfDay.format(context);

      await Firestore.instance
          .document(
              '$gbbatch/$gbbranch/MFEEQueries/$gbrollNum/${DateFormat("dd-MM-yyyy").format(now)}/${timeOfDay.format(context)}')
          .setData({
        'issue': issue.text,
        'issueType': currentSelectvalue,
        'time': res,
        'rollNum': gbrollNum,
        'batch': gbbatch,
        'branch': gbbranch,
      });
      Fluttertoast.showToast(
          msg: 'We are happy to help you ! We will get in touch with you soon.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    Widget getBox(
        String label,
        String hint,
        bool _validate,
        Icon i,
        int ml,
        int no,
        TextEditingController t,
        String errMsg,
        FocusNode cnode,
        FocusNode node,
        TextInputAction action) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: TextFormField(
          keyboardType:
              no == 1 ? TextInputType.emailAddress : TextInputType.text,
          maxLines: ml,
          controller: t,
          focusNode: cnode,
          textInputAction: action,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(node);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.black54, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            errorText: _validate ? errMsg : null,
            labelText: label,
            labelStyle: TextStyle(color: Colors.blueGrey),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            icon: i,
            hintText: hint,
            border: OutlineInputBorder(borderSide: BorderSide()),
          ),
        ),
      );
    }

    Widget selectIssueType(FocusNode node) {
      return InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.black54, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: Text(
            'Select Your Issue',
            style: TextStyle(color: Colors.black54),
          ),
          value: currentSelectvalue,
          isDense: true,
          focusNode: node,
          onChanged: (String newValue) {
            setState(() {
              currentSelectvalue = newValue;
              _validateIT = false;
            });
          },
          items: <String>['Wrong Mess Bill', 'Profile Details wrong', 'Payment']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )),
      );
    }

    Widget loadingIndicator = _load
        ? new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          )
        : new Container();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: pridarkColor,
        elevation: 7,
        title: Text(
          'mFee Queries',
          style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Icon(
                      Icons.report_problem,
                      color: pridarkColor,
                    ),
                  ),
                  Flexible(
                    child: selectIssueType(_seleIssueNode),
                    flex: 4,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                errMsgIT,
                style: TextStyle(color: Colors.red, fontSize: 12.5),
              ),
            ),
            getBox(
              'E-mail',
              'Enter your mail',
              validateM,
              Icon(
                Icons.mail,
                color: pridarkColor,
              ),
              1,
              1,
              mail,
              errMsgM,
              _emailFocusNode,
              _issueFocusNode,
              TextInputAction.next,
            ),
            getBox(
              'Issue',
              'Enter your issue',
              _validateIs,
              Icon(
                Icons.person,
                color: pridarkColor,
              ),
              6,
              2,
              issue,
              errMsgIs,
              _issueFocusNode,
              _submitFocusNode,
              TextInputAction.done,
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              focusNode: _submitFocusNode,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              color: pridarkColor,
              textColor: Colors.black,
              onPressed: () async {
                time = await DateTime.now();
                setState(() {
                  _validateIs = false;
                  validateM = false;
                  errMsgIT = '';
                  errMsgIs = '';
                  errMsgM = '';
                  var i = 0;
                  if (currentSelectvalue == null) {
                    i = 1;
                    errMsgIT = 'Must select any one type';
                  }

                  if (issue.text.isEmpty) {
                    _validateIs = true;
                    errMsgIs = 'Issue should not be  null';
                    i = 1;
                  }
                  if (mail.text.isEmpty ||
                      !EmailValidator.validate(mail.text)) {
                    validateM = true;
                    errMsgM = 'Invalid email';
                    i = 1;
                  }
                  getIStatus();
                  if (i == 0) {
                    if (iStatus) {
                      setState(() {
                        _load = true;
                        loadText = 'Wait for a while ......';
                      });
                      sendQueries().whenComplete(() {
                        setState(() {
                          _load = false;
                          loadText = '';
                          issue.clear();
                          mail.clear();
                        });
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: 'No Internet Connection',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 20,
            ),
            new Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  loadingIndicator,
                  Text(loadText),
                ],
              ),
              alignment: FractionalOffset.center,
            ),
          ],
        ),
      ),
    );
  }
}
