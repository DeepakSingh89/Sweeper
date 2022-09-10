import 'dart:io';
import 'package:Sweeper/Modal/NearDriverPoJo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NearDriverListProv extends ChangeNotifier{
  var nearDriverListData = NearDriverPoJo();

  bool loading = false;

  ///********** Near Driver List *************///
  void nearDriversList(String lat, String lng, BuildContext context) async {
    try {
      // Common.showLoading(context);
      var response = await ApiServices.nearDriverListApi(lat, lng, context);
      if (response != null) {
        // Common.showLoading(context);
        loading = true;
        notifyListeners();
        if (response.status == true) {
          if(response.data !=null){
            nearDriverListData = response;
            notifyListeners();
          }
        } else if (response.status == false) {
          // Common.showLoading(context);
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        // Common.showLoading(context);
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      // Common.showLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      // Common.showLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }


  Future<void> saveUserRoute(List<Map<String,dynamic>> routeList,String routeName ,BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.saveRoute(routeList,routeName, context);
      if (response != null) {
        loading = true;
        notifyListeners();
        if (response['status'] == "success")
        {
          Common.hideLoading(context);
          Common.show_dialog(context,response['message']);
        } else {
          Common.showSnackBar(response['message'].toString(), context, Colors.red);
        }
      } else {
        loading = true;
        notifyListeners();
       Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      loading = true;
      notifyListeners();
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      loading = true;
      notifyListeners();
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

}