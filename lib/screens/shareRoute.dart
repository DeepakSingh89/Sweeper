import 'package:Sweeper/screens/DriverFriendsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/widgets/commonButton.dart';


class ShareRoutes extends StatefulWidget {

  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<ShareRoutes> {
  bool rememberMeActive = false;
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
        title: Text("Share Routes",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*.9,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: 20,),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 15,
                        itemBuilder: (BuildContext context , int index){
                          return _routeListUi();
                        })
                  ],
                ),
              ),
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child:  Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: CommonButton(title: 'Confirm Share',onTap: (){
                     Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DriverFriends()));
                  },),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _routeListUi() {
    return Container(
      margin: EdgeInsets.only(top: 12,bottom: 12,left: 12,right: 12),
      child: ListTile(
        leading: Image(image: AssetImage('assets/images/profile.png'),),
        title: Text('Person Name'),
        trailing: rememberMeActive? GestureDetector(
            onTap: (){
              rememberMeActive=!rememberMeActive;
              setState(() {
              });
            },
            child: Icon(Icons.radio_button_checked,color: Colors.blue,)) :
        GestureDetector(
            onTap: (){
              rememberMeActive=!rememberMeActive;
              setState(() {
              });
            },
            child: Icon(Icons.radio_button_off,color: Colors.blue,)),
      ),
    );
  }
}
