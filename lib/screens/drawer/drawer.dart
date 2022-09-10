import 'package:Sweeper/screens/DriverFriendRequestListScreen.dart';
import 'package:Sweeper/screens/DriverFriendsListScreen.dart';
import 'package:Sweeper/screens/SubscriptionScreen.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/screens/NearDriversList.dart';
import 'package:Sweeper/screens/getprofile.dart';
import 'package:Sweeper/screens/routeNotification.dart';
import 'package:Sweeper/screens/savedRoutes.dart';
import 'package:Sweeper/screens/setting.dart';
import 'package:Sweeper/util/Common.dart';

class DrawerManually extends StatefulWidget {
  @override
  _DrawerManuallyState createState() => _DrawerManuallyState();
}

class _DrawerManuallyState extends State<DrawerManually> {
  @override
  void initState() {
    getRoleType();
    super.initState();
  }

  String? roleType;
  TextEditingController locationController = new TextEditingController();
  bool issShow = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 400,
        height: double.maxFinite,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Common.sizeBoxHeight(50),
              Image.asset(
                'assets/images/logo.png',
                height: 180,
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GetProfile()));
                  },
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                      child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),
              roleType == '3'
                  ? SizedBox()
                  : SizedBox(
                      height: 40,
                    ),
              roleType == '3'
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscriptionScreen()));
                      },

                  child: Container(
                    width: 400,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                      child: Text(
                        'Subscription',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),

              SizedBox(
                height: 40,
              ),
              roleType == '3'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedRoutes()));
                      },

                  child: Container(
                    width: 400,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                      child: Text(
                        'Saved Routes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ))

                  : SizedBox(),
              roleType == '3'
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(),
              roleType == '3'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NearDriverListScreen( DriverSide: ConstantsText.driverListForDriver,)));
                      },

                child: Container(
                  width: 400,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Text(
                      'Add Drivers',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                       )
                  : SizedBox(),
              roleType == '3'
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(),
              roleType == '3'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DriverFriendRequestListScreen()));
                      },

                child: Container(
                  width: 400,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                    child: Text(
                      'Driver Requests',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                       )
                  : SizedBox(),
              roleType == '3'
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(),
              roleType == '3'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DriverFriends()));
                      },

                child: Container(
                  width: 400,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Text(
                      'Driver Friends',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              )
                  : SizedBox(),
              roleType == '3'
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(),
              roleType == '3'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RouteNotification()));
                      },

                child: Container(
                  width: 400,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Text(
                      'Route Notification',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                       )
                  : SizedBox(),
              roleType == '3'
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Setting()));
                  },

                child: Container(
                  width: 400,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Text(
                      'Settings',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
                  ),
            ],
          ),
        ),
      ),
    );
  }

  getRoleType() async {
    roleType = await CustomPreferences.getPreferences(PrefKeys.roleType);
    setState(() {});
  }
}
