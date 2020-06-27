import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:location/location.dart';
import 'package:upi_pay/upi_applications.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import './shared.dart';
import './loading.dart';
import './main.dart';

class Payments extends StatefulWidget {
  String month, year, amount, billDate, stayAtHostel, costPerDay, dueDate;

  Payments(
    this.month,
    this.billDate,
    this.amount,
    this.costPerDay,
    this.dueDate,
    this.stayAtHostel,
    this.year,
  );

  @override
  _PaymentsState createState() => _PaymentsState(
        this.month,
        this.billDate,
        this.amount,
        this.costPerDay,
        this.dueDate,
        this.stayAtHostel,
        this.year,
      );
}

var payBy;
var time;
bool loading = false;
var status, message;
var txnId, txnRef, appRefNum, resCode, payStatus, imei;
double latitude, longitude;
final Location location = Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

void getLocation() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  _locationData = await location.getLocation();
  latitude = _locationData.latitude;
  longitude = _locationData.longitude;
}

class _PaymentsState extends State<Payments> {
  String month, year, amount, billDate, stayAtHostel, costPerDay, dueDate;

  _PaymentsState(this.month, this.billDate, this.amount, this.costPerDay,
      this.dueDate, this.stayAtHostel, this.year);

  Future txnStore() async {
    setState(() {
      loading = true;
    });

    initializeDateFormatting();
    DateTime now = DateTime.now();
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());

    Firestore.instance
        .document(
            '$gbbatch/$gbbranch/PaymentDetails/${gbrollNum.toUpperCase()}/PaymentHistory/$month')
        .setData({
      'paidDate': DateFormat("dd-MM-yyyy").format(now),
      'txnId': txnId,
      'payBy': payBy,
      'txnRef': txnRef,
      'resCode': resCode,
      'payStatus': 'Transaction Success',
      'status': 'Paid',
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'imei': imei.toString(),
      'time': timeOfDay.format(context),
      'rollNum': gbrollNum,
      'month': month,
      'billDate': billDate,
      'dueDate': dueDate,
      'amPDay': costPerDay,
      'amount': amount,
      'payBy': payBy,
      'year': year,
      'numDSH': stayAtHostel,
    });

    setState(() {
      loading = false;
    });
  }

  Future<void> _onTap(UpiApplication app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    final a = await UpiPay.initiateTransaction(
      amount: '1.00',
      app: app,
      receiverName: 'Raja',
      receiverUpiAddress: '9944803256@apl',
      transactionRef: transactionRef,
      merchantCode: '7372',
    );
    setState(() {
      txnId = a.txnId;
      txnRef = transactionRef;
      resCode = a.responseCode;
      appRefNum = a.approvalRefNo;
      status = a.status;
    });
    if (a.rawResponse == 'activity_unavailable' ||
        a.rawResponse == 'user_cancelled') {
    } else {
      await txnStore().whenComplete(() {});
    }

    if (a.rawResponse == 'activity_unavailable') {
      DangerAlertBox(
          context: context,
          messageText: 'Selected app is not installed',
          titleTextColor: Colors.red,
          title: 'App unavailable');
    } else if (a.rawResponse == 'user_cancelled') {
      WarningAlertBox(
          context: context,
          messageText: 'You cancelled the transaction',
          titleTextColor: Colors.orange,
          title: 'Transaction cancelled');
    } else if (a.status == UpiTransactionStatus.failure) {
      txnStore();
      if (a.status == UpiTransactionStatus.failure) {
        Firestore.instance
            .document(
                '$gbbatch/$gbbranch/PaymentDetails/${gbrollNum.toUpperCase()}/PendingDues/$month')
            .delete();
      }

      DangerAlertBox(
          context: context,
          messageText: 'Payment was failure due to some issues',
          titleTextColor: Colors.red,
          title: 'Payment Failure');
    } else if (a.status == UpiTransactionStatus.submitted) {
      txnStore();
      if (a.status == UpiTransactionStatus.submitted) {
        Firestore.instance
            .document(
                '$gbbatch/$gbbranch/PaymentDetails/${gbrollNum.toUpperCase()}/PendingDues/$month')
            .delete();
      }
      InfoAlertBox(
          context: context,
          infoMessage: 'Payment was submitted',
          titleTextColor: Colors.blue,
          title: 'Payment Submitted');
    } else if (a.status == UpiTransactionStatus.success) {
      txnStore();
      if (a.status == UpiTransactionStatus.success) {
        Firestore.instance
            .document(
                '$gbbatch/$gbbranch/PaymentDetails/${gbrollNum.toUpperCase()}/PendingDues/$month')
            .delete();
      }
      SuccessAlertBox(
          context: context,
          messageText: 'Payment was successful',
          titleTextColor: Colors.green,
          title: 'Payment Success');
    }
  }

  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getId();
      print(platformImei);
    } catch (PlatformException) {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
    
    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
      imei = uniqueId;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle billTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontSize: MediaQuery.of(context).size.width / 22.5,
    );

    Widget getText(String txt) {
      return Text(
        txt,
        style: billTextStyle,
      );
    }

    Widget billContainer() {
      return Container(
        height: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 30,
            right: MediaQuery.of(context).size.width / 30,
            top: MediaQuery.of(context).size.width / 60,
            bottom: MediaQuery.of(context).size.width / 60),
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20,
            top: MediaQuery.of(context).size.width / 400),
        decoration: BoxDecoration(
          color: pridarkColor,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText('Total Bill'),
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText('Bill Date'),
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText('Due Date'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText(amount),
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText(billDate),
                SizedBox(height: MediaQuery.of(context).size.width / 80),
                getText(dueDate),
              ],
            ),
          ],
        ),
      );
    }

    Widget leftWidget(TextStyle _style, String txt, Icon i, String lbl) {
      return TextFormField(
        initialValue: txt,
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Colors.blueGrey, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          labelText: lbl,
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
        style: _style,
      );
    }

    TextStyle detailsTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: MediaQuery.of(context).size.width / 24,
    );

    Widget getText1(String txt) {
      return Text(
        txt,
        style: TextStyle(fontSize: 16),
      );
    }

    Widget _billDetails(BuildContext context, double ht, double wt) {
      return Container(
        decoration: BoxDecoration(
          color: primaryLightColor,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: ht / 10,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 30,
            right: MediaQuery.of(context).size.width / 30,
            top: MediaQuery.of(context).size.width / 60,
            bottom: MediaQuery.of(context).size.width / 60),
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20,
            top: MediaQuery.of(context).size.width / 400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getText1('Number of days stay in Hostel'),
                getText1('Cost per Day'),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getText1("$stayAtHostel days"),
                getText1("\u20B9 $costPerDay"),
              ],
            ),
          ],
        ),
      );
    }

    Widget flatButton(String path, int i) {
      return FlatButton(
        onPressed: () {
          var j = 0;
          getLocation();
          if (!_serviceEnabled) {
            j = 1;
          }

          if (i == 1 && j == 0) {
            payBy = 'Google Pay';
            _onTap(UpiApplication.googlePay);
          }
          if (i == 2 && j == 0) {
            payBy = 'Amazon Pay';
            _onTap(UpiApplication.amazonPay);
          }
          if (i == 3 && j == 0) {
            payBy = 'PayTM';
            _onTap(UpiApplication.payTM);
          }
          if (i == 4 && j == 0) {
            payBy = 'PhonePe';
            _onTap(UpiApplication.phonePe);
          }
          if (i == 5 && j == 0) {
            payBy = 'Bhim UPI';
            _onTap(UpiApplication.bhim);
          }
          if (i == 6 && j == 0) {
            payBy = 'My Airtel UPI';
            _onTap(UpiApplication.myAirtelUpi);
          }
        },
        child: Image.asset(
          path,
          height: MediaQuery.of(context).size.width / 8,
          width: MediaQuery.of(context).size.width / 8,
        ),
      );
    }

    Widget getAppIcon(String path, int i, String txt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          flatButton(path, i),
          SizedBox(
            height: MediaQuery.of(context).size.width / 60,
          ),
          Text(txt),
        ],
      );
    }

    Widget iconContainer() {
      return Container(
        margin: EdgeInsets.only(top: 18, bottom: 32),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 18),
              child: Text(
                'Pay Using',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: MediaQuery.of(context).size.width / 25),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getAppIcon('images/gpay.png', 1, 'Google Pay'),
                  getAppIcon('images/amazon.png', 2, 'Amazon Pay'),
                  getAppIcon('images/paytm.png', 3, 'PayTM'),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getAppIcon('images/phonepe.png', 4, 'PhonePe'),
                  getAppIcon('images/bhim.png', 5, 'Bhim'),
                  getAppIcon('images/airtel.png', 6, 'My Airtel UPI'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                month + ' - ' + year,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.width / 10),
                      billContainer(),
                      SizedBox(height: MediaQuery.of(context).size.width / 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Bill Details',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 40),
                      _billDetails(context, MediaQuery.of(context).size.height,
                          MediaQuery.of(context).size.width),
                    ],
                  ),
                ),
                iconContainer(),
              ],
            ),
          );
  }
}
