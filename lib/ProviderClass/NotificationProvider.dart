import 'dart:io';

import 'package:Sweeper/Modal/RouteNotificationPoJo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteNotificationProvider extends ChangeNotifier{

  var routeNotificationData = RouteNotificationPoJo();
  bool loading = false;

  ///**************** Get Route Notification ***************///
  void getRouteNotificationList(BuildContext context) async{
    try {
      loading = false;
      notifyListeners();

      var response = await ApiServices.getRouteNotificationApi(context);

      if (response != null) {
        loading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){

            routeNotificationData = response;

            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///*************** Accept & reject Route Request Api *************///
  void acceptAndRejectRouteRequest(String routeId, String status ,BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.routeAcceptAndReject(context, routeId, status);
      if (response != null) {
        if (response['status'] == "success") {
          Common.hideLoading(context);
          loading = false;
          Common.showSnackBar(response['message'], context, Colors.grey);
          notifyListeners();
          getRouteNotificationList(context);
        } else if (response['status'] == "fail") {
          Common.hideLoading(context);
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