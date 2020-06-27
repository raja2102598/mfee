import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared.dart';
import '../signup/secQues.dart';

class HostelDet extends StatefulWidget {
  @override
  _HostelDetState createState() => _HostelDetState();
}

class _HostelDetState extends State<HostelDet> {
  bool _validateRoom = false;
  bool _validateHN = false;
  bool _validateHJD = false;
  String hJD;
  String errMsgHName = '';
  String errMsgHJD = '';
  var currentSelectvalueHName;
  var currentSelectvalueHJD;

  String hRoomno, hName, hJoiningData;
  bool loading = false;
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TextEditingController TroomNum = TextEditingController();

  @override
  void dispose() {
    TroomNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget selectHostel() {
      return InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 23),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: Text(
            'Select Your Hostel',
            style: TextStyle(color: Colors.white),
          ),
          value: currentSelectvalueHName,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              currentSelectvalueHName = newValue;
              _validateHN = false;
            });
          },
          items: <String>['Ponni Hostel', 'Chola Hostel']
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
    ) {
      return TextFormField(
        controller: TroomNum,
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
            _validateRoom = false;
          }
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: size.width / 20, vertical: 0),
          height: MediaQuery.of(context).size.height,
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
                SizedBox(
                  height: size.width / 20,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('images/clgicon.png',
                        height: MediaQuery.of(context).size.width / 2.4),
                  ],
                ),
                SizedBox(
                  height: size.width / 10,
                ),
                Text(
                  'Hostel Info',
                  style: titleTextStyle.copyWith(
                      fontSize: size.width / 12,
                      letterSpacing: 1.5,
                      color: Colors.white),
                ),
                SizedBox(
                  height: size.width / 20,
                ),
                selectHostel(),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      errMsgHName,
                      style: TextStyle(color: Colors.red, fontSize: 12.5),
                    )),
                inputBox(
                    'Your Room Number',
                    'Room Number should not empty',
                    1,
                    _validateRoom,
                    TextInputType.number,
                    Icon(Icons.home, size: 28, color: Colors.white)),
                SizedBox(
                  height: size.width / 40,
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 60,
                        ),
                        Icon(Icons.calendar_today,
                            size: 28, color: Colors.white),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 70,
                        ),
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(color: Colors.black, fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        Text('Hostel Joining Date',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      errMsgHJD,
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
                          errMsgHName = '';
                          errMsgHJD = '';
                          hJD = "${selectedDate.toLocal()}".split(' ')[0];
                          var i = 0;
                          if (TroomNum.text.isEmpty) {
                            _validateRoom = true;
                            i = 1;
                          }

                          if (currentSelectvalueHName == null) {
                            i = 1;
                            errMsgHName = 'Must select any one Hostel';
                          }
                          var check = "${DateTime.now().toLocal()}"
                              .split(' ')[0]
                              .toString();
                          if (hJD == check) {
                            _validateHJD = true;
                            errMsgHJD = 'Must select your Hostel Joining Date';
                            i = 1;
                          }
                          currentSelectvalueHJD = "${selectedDate.toLocal()}"
                              .split(' ')[0]
                              .toString();

                          if (i == 0) {
                            signupPrefs.setString('hRoomNum', TroomNum.text);
                            signupPrefs.setString(
                                'hJoinDate', currentSelectvalueHJD);
                            signupPrefs.setString(
                                'hName', currentSelectvalueHName);
                            Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                    fullscreenDialog: false,
                                    builder: (BuildContext context) =>
                                        SecQues()));
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
