import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_fonts/google_fonts.dart';

import './shared.dart';

String billDate;
String payment;

class DetailPage extends StatelessWidget {
  String month,
      year,
      amount,
      paidDate,
      billDate,
      time,
      stayAtHostel,
      costPerDay,
      dueDate,
      payUsing,
      txnId,
      txnRef;

  DetailPage(
      this.month,
      this.billDate,
      this.amount,
      this.costPerDay,
      this.dueDate,
      this.paidDate,
      this.payUsing,
      this.stayAtHostel,
      this.time,
      this.txnId,
      this.txnRef,
      this.year);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

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
          contentPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width / 30,
              horizontal: MediaQuery.of(context).size.width / 20),
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
      fontSize: MediaQuery.of(context).size.width / 25,
    );
    TextStyle billTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 1,
      fontSize: MediaQuery.of(context).size.width / 22.5,
    );

    Widget getText(String txt) {
      return Text(
        txt,
        style: billTextStyle,
      );
    }

    Widget _paymentDetails(BuildContext context, double ht, double wt) {
      return Container(
        decoration: BoxDecoration(
          color: primaryLightColor,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: ht / 3.5,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 30,
            right: MediaQuery.of(context).size.width / 30,
            top: MediaQuery.of(context).size.width / 60,
            bottom: MediaQuery.of(context).size.width / 60),
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20,
            top: MediaQuery.of(context).size.width / 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            leftWidget(
                detailsTextStyle, payUsing, Icon(Icons.phone), 'Pay by using'),
            leftWidget(detailsTextStyle, txnId.length == 0 ? 'Nill' : txnId,
                Icon(Icons.phone), 'Transaction ID'),
            leftWidget(detailsTextStyle, txnRef, Icon(Icons.phone),
                'Transaction Reference'),
          ],
        ),
      );
    }

    Widget getText1(String txt) {
      return Text(
        txt,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
      );
    }

    Widget _billDetails(BuildContext context, double ht, double wt) {
      return Container(
        decoration: BoxDecoration(
          color: primaryLightColor,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: ht / 5.5,
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
                getText1('Bill Date'),
                getText1('Due Date'),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getText1('$stayAtHostel days'),
                getText1("\u20B9 $costPerDay"),
                getText1(billDate),
                getText1(dueDate),
              ],
            ),
          ],
        ),
      );
    }

    String msg = """GCETJ mFEE Details\n
Month     :  '${month}'
Year         : "${year}"
Amount   : ${amount}\n
Thanks for using GCETJ mFee App""";
    final readButton = Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenSize.width / 4, vertical: 0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            FlutterShareMe().shareToWhatsApp(msg: msg);
          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
              Text("SHARE VIA WHSAPP", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      child: Center(
        child: Column(
          children: <Widget>[readButton],
        ),
      ),
    );

    Widget billContainer() {
      return Container(
        height: MediaQuery.of(context).size.width / 4.2,
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getText('Total Bill'),
                SizedBox(height: MediaQuery.of(context).size.width / 100),
                getText('Paid on'),
                SizedBox(height: MediaQuery.of(context).size.width / 100),
                getText('Time'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getText("\u20B9 $amount"),
                SizedBox(height: MediaQuery.of(context).size.width / 100),
                getText(paidDate),
                SizedBox(height: MediaQuery.of(context).size.width / 100),
                getText(time),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          billContainer(),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Bill Details',
              style: TextStyle(
                  fontSize: 17,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _billDetails(context, MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Payment History',
              style: TextStyle(
                  fontSize: 17,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _paymentDetails(context, MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width),
          bottomContent,
        ],
      ),
    );
  }
}
