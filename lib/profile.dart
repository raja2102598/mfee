import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './shared.dart';
import './mFee_queries.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget _buildProfileImage(double wt) {
    var g = 'Male';
    var path;
    if (g == 'Male') {
      path = 'images/male.png';
    } else if (g == 'Female') {
      path = 'images/female.png';
    } else {
      path = 'images/female.png';
    }
    return Center(
      child: Container(
        width: wt / 4,
        height: wt / 4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(path),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: MediaQuery.of(context).size.width / 16.5,
      fontWeight: FontWeight.w700,
    );

    return Text(
      name,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        rollno,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          backgroundColor: Colors.white,
          fontSize: MediaQuery.of(context).size.width / 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget leftWidget(TextStyle _style, String txt, Icon i, String lbl) {
    return TextFormField(
      initialValue: txt,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: secondaryColor,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        labelText: lbl,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: i,
      ),
      style: _style,
    );
  }

  Widget _buildDetails(BuildContext context, double ht, double wt) {
    TextStyle detailsTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontSize: wt / 25,
    );
    var a = address.length;
    var ml;
    if (a < 50)
      ml = 2;
    else if (a > 50 && a < 70)
      ml = 2;
    else if (a > 70 && a < 80)
      ml = 4;
    else if (a > 90 && a < 100)
      ml = 5;
    else
      ml = 8;

    return Container(
      padding: EdgeInsets.only(left: wt / 20, top: wt / 30, right: wt / 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leftWidget(detailsTextStyle, email, Icon(Icons.email), 'E-mail'),
          SizedBox(height: wt / 23),
          leftWidget(
              detailsTextStyle, mobnum, Icon(Icons.phone), 'Mobile Number'),
          SizedBox(height: wt / 23),
          TextFormField(
            textAlign: TextAlign.left,
            initialValue: address.trim(),
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: secondaryColor,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              labelText: 'Address',
              labelStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.place),
            ),
            maxLines: ml,
            style: detailsTextStyle,
          ),
          SizedBox(height: wt / 23),
          Row(
            children: <Widget>[
              SizedBox(
                  width: wt / 2.1,
                  child: leftWidget(
                      detailsTextStyle, batch, Icon(Icons.school), 'Batch')),
              SizedBox(width: wt / 25),
              Flexible(
                  child: leftWidget(
                      detailsTextStyle, branch, Icon(Icons.school), 'Branch')),
            ],
          ),
          SizedBox(height: wt / 23),
          Row(
            children: <Widget>[
              SizedBox(
                width: wt / 2.1,
                child: leftWidget(detailsTextStyle, joindate,
                    Icon(Icons.date_range), 'Join Date'),
              ),
              SizedBox(width: wt / 23),
              Flexible(
                child: leftWidget(detailsTextStyle, roomno,
                    Icon(Icons.local_hotel), 'Room No'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(Size screenSize, double w) {
    return Container(
      width: screenSize.width / w,
      height: 1.0,
      color: Colors.blueGrey,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Get in Touch with GCETJDC",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: MediaQuery.of(context).size.width / 25),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0, horizontal: MediaQuery.of(context).size.width / 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: pridarkColor,
                ),
                child: Center(
                  child: Text(
                    "SIGN OUT",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: MediaQuery.of(context).size.width / 27.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => MFeeQueries())),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE TO m-FEE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontSize: MediaQuery.of(context).size.width / 27.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenSize.width / 20),
            _buildProfileImage(screenSize.width),
            _buildFullName(),
            _buildStatus(context),
            _buildDetails(context, screenSize.height, screenSize.width),
            SizedBox(height: screenSize.width / 20),
            _buildSeparator(screenSize, 1.4),
            SizedBox(height: screenSize.width / 60),
            _buildGetInTouch(context),
            SizedBox(height: screenSize.width / 60),
          ],
        ),
      ),
    );
  }
}
