import 'package:Sweeper/screens/map/starttrip.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/screens/map/homeMap.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:Sweeper/widgets/commonButton.dart';

class LocationAccess extends StatefulWidget {
  String? roleType;
  LocationAccess({this.roleType});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationAccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on,size: 150,color: Colors.black54,),
            SizedBox(height: 28,),
            Text('We need location access permission',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black54,),),
            SizedBox(height: 28,),
            CommonButton(title: 'Allow Access', onTap: () async{
              await CustomPreferences.setPreferences(PrefKeys.locationPage, "Yes");
              widget.roleType == "3"
                  ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartTrip()),
                      (Route<dynamic> route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
            }),
          ],
        ),
      ),
    );
  }
}
