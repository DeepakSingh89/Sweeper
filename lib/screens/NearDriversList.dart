import 'package:Sweeper/ProviderClass/GetLocation.dart';
import 'package:Sweeper/screens/map/Driver_list.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/screens/routeNotification.dart';
import 'package:provider/provider.dart';

class NearDriverListScreen extends StatefulWidget {
 final bool DriverSide;
  const  NearDriverListScreen( {required this.DriverSide,Key? key}) : super(key: key);

  @override
  _NearDriverListScreenState createState() => _NearDriverListScreenState(DriverSide);
}

class _NearDriverListScreenState extends State<NearDriverListScreen> {
    bool DriverSide;
  _NearDriverListScreenState(bool this.DriverSide);

  @override
  void initState() {

    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) => {getDriverlist()});

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
          'Near Drivers',
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: Common.displayHeight(context),
        width: Common.displayWidth(context),
        child: Consumer<Driverlist>(
            builder: (BuildContext context, modal, Widget? child) {
          return modal.loading
              ? modal.driverData != null && modal.driverData!.data!.length > 0
                  ? ListView.builder(
              physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: modal.driverData!.data!.length,
                      itemBuilder: (BuildContext context, int index) {

                        return _friendListUi(
                            modal.driverData!.data![index]);
                      })
                  : Center(
                      child: new Text(
                        'No Drivers found.',
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

  Widget _friendListUi(Data modal) {
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
          title: Text(modal.name!),
          trailing: InkWell(
            onTap: (){
              if(modal.status !=null && modal.status == "no friend"){
                Provider.of<Driverlist>(context, listen: false)
                    .sendFriendRequest(modal.id.toString(), context);
              }else if(modal.status !=null && modal.status == "rejected"){
                Provider.of<Driverlist>(context, listen: false)
                    .sendFriendRequest(modal.id.toString(), context);
              }
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
                modal.status !=null && modal.status == "no friend"
                ?  'Send Request'
                : modal.status !=null && modal.status == "requested"
                ? "Requested"
                : modal.status !=null && modal.status == "rejected"
                ? "Rejected"
                : modal.status !=null && modal.status == "accepted"
                ?  "Friend"
                : "",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
      ),
    );
  }

  getDriverlist() async {
    Provider.of<Driverlist>(context, listen: false).loading = false;
    await Provider.of<GetLocation>(context, listen: false).showlocation(context);
    Provider.of<Driverlist>(context, listen: false).driverData = null;
    if(Provider.of<GetLocation>(context, listen: false).locationData != null &&
        Provider.of<GetLocation>(context, listen: false)
            .locationData!
            .latitude !=
            null &&
        Provider.of<GetLocation>(context, listen: false)
            .locationData!
            .longitude !=
            null){
if(DriverSide==true){

        await Provider.of<Driverlist>(context, listen: false).driverListForDriver(context,
      Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .latitude.toString(),
      Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .longitude.toString()


  );

}else{

  await Provider.of<Driverlist>(context, listen: false).driverList(context,
      Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .latitude.toString(),
      Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .longitude.toString()
  );
}

    }
  }

}
