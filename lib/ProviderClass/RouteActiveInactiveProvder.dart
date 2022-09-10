import 'dart:io';

import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteActiveInActiveProvider extends ChangeNotifier{



  ///*************** Route Active Api *************///
  void routeActive(String routeId, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.routeActiveApi(context, routeId);
      if (response != null) {
        Common.hideLoading(context);
        if (response.status == "success") {
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


  ///*************** Route InActive Api *************///
  void routeInActive(String routeId, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.routeInActiveApi(context, routeId);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == "success") {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.black);
          Navigator.pop(context);
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
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