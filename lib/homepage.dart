import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './main.dart';
import './shared.dart';
import './dues.dart';
import './history.dart';
import './main_drawer.dart';
import './profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    Dues(),
    History(),
    Profile(),
  ];

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            elevation: 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              'Are you sure?',
              style: titleTextStyle.copyWith(color: pridarkColor),
            ),
            content: Text('Do you want to exit an App',
                style: subtitleTextStyle.copyWith(color: pridarkColor)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 20),
                child: new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onItemTapped(int index) {
    if (index == 1) History();
    setState(() {
      if (index == 1) History();
      _selectedIndex = index;
    });
  }

  String title;

  @override
  void initState() {
    getAppbar();
    storeLastLogin(context);
  }

  Widget getAppbar() {
    getProfileP();
    if (_selectedIndex == 1) title = 'Mess Fee History';
    if (_selectedIndex == 0) title = 'Pending Dues';
    if (_selectedIndex == 2) title = 'Profile';
    return AppBar(
      backgroundColor: pridarkColor,
      title: Text(
        title,
        style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
      ),
      actions: <Widget>[
        Text(
          'Beta Testing',
          style: TextStyle(fontSize: 15, color: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'GCETJ mFEE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: MainDrawer(),
          backgroundColor: Colors.white,
          appBar: getAppbar(),
          body: _children[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: pridarkColor,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                title: Text('Dues'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Profile'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

getProfileP() async {
  Firestore.instance
      .document('$gbbatch/$gbbranch/Profile/$gbrollNum')
      .get()
      .then((DocumentSnapshot ds) {
    name = ds['sName'];
    mobnum = ds['sMobNum'];
    email = ds['sMail'];
    address = ds['sAddress'];
    rollno = ds['rollNum'];
    batch = ds['batch'];
    branch = ds['branch'];
    joindate = ds['hJoinDate'];
    roomno = ds['hRoomNum'];
  });
}
