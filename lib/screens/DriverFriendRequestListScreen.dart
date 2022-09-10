import 'package:Sweeper/Modal/DriverRequestListPojo.dart';
import 'package:Sweeper/ProviderClass/DriverRequestProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/screens/routeNotification.dart';
import 'package:provider/provider.dart';

class DriverFriendRequestListScreen extends StatefulWidget {
  @override
  _DriverFriendRequestListScreenState createState() => _DriverFriendRequestListScreenState();
}

class _DriverFriendRequestListScreenState extends State<DriverFriendRequestListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) => {getDriverFriendsRequestList()});
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
          'Friend Request',
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        // actions: [
        //   IconButton(onPressed: (){},
        //     icon: Icon(Icons.search, color: Colors.black,),),
        // ],
      ),
      body: Container(
        color: Colors.white,
        height: Common.displayHeight(context),
        width: Common.displayWidth(context),
        child: Consumer<DriverRequestProvider>(
            builder: (BuildContext context, modal, Widget? child) {
              return modal.loading
                  ? modal.driveRequestListData.data !=null &&
                  modal.driveRequestListData.data!.length > 0
                  ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: modal.driveRequestListData.data!.length,
                  itemBuilder: (context, index) {
                    return _friendListUi(
                        modal.driveRequestListData.data![index]);
                  })
                  : Center(
                  child: new Text(
                  'No Request found',
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
          trailing: InkWell(
            onTap: (){
              requestPopup(context,modal.driverId.toString() ,"Do you really want to accept this friend request." );
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

  requestPopup(BuildContext context, String driverId ,String message){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Common.sizeBoxHeight(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.055,
                        minWidth: MediaQuery.of(context).size.width * 0.27,
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                        ),
                      ),
                      Common.sizeBoxWidth(14),
                      MaterialButton(
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.blue,
                        height: MediaQuery.of(context).size.height * 0.055,
                        minWidth: MediaQuery.of(context).size.width * 0.27,
                        textColor: Theme.of(context).primaryColor,
                        onPressed: (){
                          Provider.of<DriverRequestProvider>(context, listen: false)
                              .acceptFriendRequest(driverId.toString(), context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  getDriverFriendsRequestList() async {
    Provider.of<DriverRequestProvider>(context, listen: false).loading = false;
    Provider.of<DriverRequestProvider>(context, listen: false)
        .driverFriendsRequestList(context);
  }
}
