import 'package:Sweeper/Modal/RouteNotificationPoJo.dart';
import 'package:Sweeper/ProviderClass/NotificationProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class RouteNotification extends StatefulWidget {
  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<RouteNotification> {
  @override
  void initState() {
    Provider.of<RouteNotificationProvider>(context, listen: false).loading =
        false;
    Provider.of<RouteNotificationProvider>(context, listen: false)
        .getRouteNotificationList(context);
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
        title: Text(
          "Route Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<RouteNotificationProvider>(
        builder: (context, modal, child) {
          return modal.loading
              ? modal.routeNotificationData.data != null &&
                      modal.routeNotificationData.data!.length > 0
                  ? Container(
                      height: Common.displayHeight(context),
                      width: Common.displayWidth(context),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: modal.routeNotificationData.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _routeListUi(
                                modal.routeNotificationData.data![index]);
                          }),
                    )
                  : Center(
                      child: new Text(
                        'No Notifications found.',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    )
              : Center(
                  child: Common.loadingIndicator(Colors.blue),
                );
        },
      ),
    );
  }

  Widget _routeListUi(Datum data) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Common.displayWidth(context) * 0.48,
                    child: Text(
                      data.extra !=null &&
                      data.extra!.routeName !=null
                          ? data.extra!.routeName.toString()
                      : "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  data.title == "Route is shared"
                      ? Row(
                          children: [
                            Text(
                              'shared by',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            data.extra !=null &&
                                data.extra!.sharedByProfilePic != null &&
                                data.extra!.sharedByProfilePic !=""
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(data
                                        .extra!.sharedByProfilePic
                                        .toString()),
                                  )
                                : Image(
                                    image:
                                        AssetImage('assets/images/profile.png'),
                                    height: 30,
                                    width: 30,
                                  )
                          ],
                        )
                      : Text(data.extra !=null &&
                      data.extra!.sharedDate != null
                      ? DateFormat.yMMMd()
                        .format(DateTime
                        .parse(data.extra!.sharedDate
                        .toString()))
                    : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                        )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: 200,
              child: Image.asset(
                "assets/images/route_map.png",
                fit: BoxFit.cover,
              ),
            ),
            data.title == "Route is shared"
                ? Text(
                data.extra !=null &&
                    data.extra!.sharedDate != null
                    ? DateFormat.yMMMd()
                    .format(DateTime
                    .parse(data.extra!.sharedDate
                    .toString()))
                    : "",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 20,
            ),
            data.title == "Route is shared"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<RouteNotificationProvider>(context, listen: false)
                          .acceptAndRejectRouteRequest(data.extra!.routeId.toString(),
                              "rejected", context);
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          child: Text(
                            'Reject',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<RouteNotificationProvider>(context, listen: false)
                              .acceptAndRejectRouteRequest(data.extra!.routeId.toString(),
                              "accepted", context);
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5.0,
                                ),
                              ],
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          child: Text(
                            'Accept',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   data.extra !=null &&
                      //       data.extra!.response !=null ?
                      //   data.extra!.response.toString()+' by'
                      //   : "",
                      //   style: TextStyle(
                      //       fontSize: 16, fontWeight: FontWeight.w500),
                      // ),
                      SizedBox(
                        width: 10,
                      ),
                      data.extra !=null &&
                          data.extra!.sharedByProfilePic != null &&
                          data.extra!.sharedByProfilePic !=""
                          ? CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(data
                            .extra!.sharedByProfilePic
                            .toString()),
                      )
                          : Image(
                        image:
                        AssetImage('assets/images/profile.png'),
                        height: 30,
                        width: 30,
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
