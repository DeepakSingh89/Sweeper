
import 'package:Sweeper/screens/map/homeMap.dart';
import 'package:Sweeper/screens/map/starttrip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sweeper/screens/auth/login.dart';



class SplashScreen extends StatefulWidget {

  String? roleType = "";
  String? screenStatus = "";
  SplashScreen({this.screenStatus, this.roleType});

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    callScreen();
  }
  //Call screen based on conditions
  callScreen() async {
    Future.delayed(Duration(seconds: 3), () {
     widget.screenStatus == "Login"
         ?  Navigator.pushReplacement(context,
         MaterialPageRoute(builder: (context) => Login()))
     : widget.roleType == "3"
         ? Navigator.pushReplacement(context,
         MaterialPageRoute(builder: (context) => StartTrip()))
     : Navigator.pushReplacement(context,
         MaterialPageRoute(builder: (context) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //  appSizeInit(context);
    return SafeArea(
      right: false,
      bottom: false,
      left: false,
      top: false,
      child: Scaffold(
          backgroundColor: Color(0xff2f2e41),
          body: Container(
            width: double.maxFinite,
            color: Colors.white,
            child:    Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    // color:Colors.white,
                    width: MediaQuery.of(context).size.height*1,
                    height: MediaQuery.of(context).size.height*1,
                    fit: BoxFit.fitHeight,
                    image: new AssetImage('assets/images/splash.png'),
                  ),
                ],
              ),
            ),
          )),
    );
  }





  @override
  void dispose() {
    super.dispose();
  }
}
