import 'dart:io';
import 'package:Sweeper/Modal/DriverRequestListPojo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverRequestProvider extends ChangeNotifier{

  var driveRequestListData = DriverRequestListPoJo();

  bool loading = false;

  ///*************** Driver Friends Request List Api *************///
  void driverFriendsRequestList(BuildContext context) async {
    try {
      loading = false;
      notifyListeners();
      var response = await ApiServices.driversFriendsRequestListApi(context);
      if (response != null) {
        loading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){
            driveRequestListData = response;
            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
      }
    } on SocketException {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
    }
  }


  ///*************** Accept Friend Request Api *************///
  void acceptFriendRequest(String driverId, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.acceptFriendRequestApi(driverId, context);
      if (response != null) {
        Common.hideLoading(context);
        if (response.status == "success") {
          int dataIndex = driveRequestListData.data!
              .indexWhere((element) => element.id == int.parse(driverId));
          driveRequestListData.data!.removeAt(dataIndex);
          notifyListeners();
          Navigator.pop(context);
          Common.showSnackBar(response.message.toString(), context, Colors.black);
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
    }
  }


}