import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './shared.dart';
import './main.dart';
import './payments.dart';

class Dues extends StatefulWidget {
  @override
  _DuesState createState() => _DuesState();
}

class _DuesState extends State<Dues> {
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(
                '$gbbatch/$gbbranch/PaymentDetails/${gbrollNum.toUpperCase()}/PendingDues')
            .orderBy('billDate', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SizedBox();
            default:
              return new GridView.count(
                primary: false,
                childAspectRatio: (wt / 500),
                padding: EdgeInsets.all(ht / 60),
                crossAxisSpacing: ht / 35,
                mainAxisSpacing: ht / 35,
                crossAxisCount: 2,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: false,
                          builder: (BuildContext context) => Payments(
                            document['month'],
                            document['billDate'],
                            document['amount'],
                            document['amPDay'],
                            document['dueDate'],
                            document['numDSH'],
                            document['year'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryLightColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(wt / 10),
                            topRight: Radius.circular(wt / 10)),
                        border: Border.all(
                            width: 2,
                            color: Colors.green,
                            style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          getImage(document['month'], ht),
                          SizedBox(height: wt / 60),
                          Text(
                            "Bill Date",
                            style:
                                subtitleTextStyle.copyWith(fontSize: wt / 28),
                          ),
                          SizedBox(height: wt / 120),
                          Text(
                            document['billDate'],
                            style: titleTextStyle.copyWith(
                                fontSize: wt / 23, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: wt / 40),
                          Text(
                            "Amount",
                            style:
                                subtitleTextStyle.copyWith(fontSize: wt / 28),
                          ),
                          SizedBox(height: wt / 120),
                          Text(
                            "\u20B9 ${document['amount']}",
                            style: titleTextStyle.copyWith(
                                fontSize: wt / 23, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
