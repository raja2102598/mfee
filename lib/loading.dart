import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('images/clgicon.png'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 1.6,
              ),
              Text(
                "Loading ...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              SpinKitRing(
                color: Colors.white,
                size: 50,
                lineWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
