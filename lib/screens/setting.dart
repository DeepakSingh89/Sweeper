import 'dart:io';

import 'package:Sweeper/screens/ChangePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/ForgotChangePass.dart';
import 'package:Sweeper/screens/privatePolice.dart';
import 'package:Sweeper/screens/termsCondition.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Setting> {
  bool _switchValue=true;

  @override
  void initState(){
    getNotifyValue();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Settings",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notification",style: TextStyle(color: Colors.black,fontSize: 20),),
                Consumer<UserAuthProvider>(
                  builder: (context, modal, child){
                    return CupertinoSwitch(
                      activeColor: Color(0xff18ADBF),
                      value: modal.notificationOnOff,
                      onChanged: (value) {
                        if (modal.notificationOnOff == true) {
                          modal.notificationOnOf("0", context);
                        } else {
                          modal.notificationOnOf("1", context);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.04,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change Password",style: TextStyle(color: Colors.black,fontSize: 20),),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivatePolicy()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Privacy Policy",style: TextStyle(color: Colors.black,fontSize: 20),),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsCondition()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Terms & Conditions",style: TextStyle(color: Colors.black,fontSize: 20),),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            GestureDetector(
              onTap: (){
                wantToLogoutPopup(context, "Are you sure you want to logout ?.");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Logout",style: TextStyle(color: Colors.blue,fontSize: 20),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Want to logout Popup
  wantToLogoutPopup(BuildContext context, message) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Common.sizeBoxWidth(25),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Provider.of<UserAuthProvider>(context,listen: false).logout(context);
                    },
                  ),
                ],
              ),
            ],
          )
              : AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Common.sizeBoxWidth(25),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Provider.of<UserAuthProvider>(context,listen: false).logout(context);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  getNotifyValue() async{
    await Provider.of<UserAuthProvider>(context, listen: false).getNotificationOnOff();
  }

}
