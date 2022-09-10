import 'package:Sweeper/Modal/DriverFriendsListPoJo.dart';
import 'package:Sweeper/ProviderClass/DriverFriendsProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/screens/routeNotification.dart';
import 'package:provider/provider.dart';

class DriverFriends extends StatefulWidget {
  @override
  _DriverFriendsState createState() => _DriverFriendsState();
}

class _DriverFriendsState extends State<DriverFriends> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) => {getDriverFriendsList()});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Driver Friends',
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
          color: Colors.black),
        ),
        // actions: [
        //   IconButton(onPressed: (){},
        //       icon: Icon(Icons.search, color: Colors.black,),),
        // ],
      ),
      body: Container(
        color: Colors.white,
        height: Common.displayHeight(context),
        width: Common.displayWidth(context),
        child: Consumer<DriverFriendsProvider>(
            builder: (BuildContext context, modal, Widget? child) {
              return modal.loading
                ? modal.driverFriendListData.data !=null &&
              modal.driverFriendListData.data!.length > 0
                  ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: modal.driverFriendListData.data!.length,
                  itemBuilder: (context, index) {
                    return _friendListUi(
                        modal.driverFriendListData.data![index]);
                  })
                  : Center(
                child: new Text(
                  'No record found',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )
              : Common.loadingIndicator(Colors.blue);
            }),
      ),
    );
  }

  Widget _friendRequestListUi() {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
      child: ListTile(
          leading: Image(
            image: AssetImage('assets/images/profile.png'),
          ),
          title: Text('Person Name'),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RouteNotification()));
            },
            child: Container(
              height: 30,
              width: 95,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5.0,
                ),
              ], color: Colors.blue, borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: Text(
                'Accept',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          )),
    );
  }

  Widget _friendListUi(Datum modal) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
      child: ListTile(
          leading: modal.profilePic == ''
              ? CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.png'),
          )
              : CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 20,
            backgroundImage: NetworkImage(modal.profilePic.toString()),
          ),
          title: Text(modal.name !=null ? modal.name.toString() : ""),
          // trailing: Container(
          //   height: 30,
          //   width: 95,
          //   decoration: BoxDecoration(boxShadow: [
          //     BoxShadow(
          //       color: Colors.black,
          //       blurRadius: 5.0,
          //     ),
          //   ], color: Colors.blue, borderRadius: BorderRadius.circular(4)),
          //   alignment: Alignment.center,
          //   child: Text(
          //     'Remove Friend',
          //     style: TextStyle(fontSize: 10, color: Colors.white),
          //   ),
          // ),
      ),
    );
  }

  getDriverFriendsList() async {
    Provider.of<DriverFriendsProvider>(context, listen: false).loading = false;
     Provider.of<DriverFriendsProvider>(context, listen: false).driverFriendsList(context);
  }
}
