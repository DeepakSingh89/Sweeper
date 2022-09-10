import 'dart:io';

import 'package:Sweeper/Modal/DriverFriendsListPoJo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/material.dart';

class DriverFriendsProvider extends ChangeNotifier{

  var driverFriendListData = DriverFriendsListPoJo();
  bool loading = false;

  int isSelectedValue = -1;
  int selectedDriverId = 0;
  String selectedDriverName = "";



  void selectDriver(int i)
  {
    isSelectedValue = i;
    selectedDriverId = driverFriendListData.data![i].driverId as int;
    selectedDriverName = driverFriendListData.data![i].name.toString();
    notifyListeners();
    print("Selected Driver ID: " + selectedDriverId.toString());
    print("Selected Driver Name: " + selectedDriverName.toString());
  }


  ///*************** Driver Friends List Api *************///
  void driverFriendsList(BuildContext context) async {
    try {
      loading = false;
      notifyListeners();
      var response = await ApiServices.driversFriendsListApi(context);
      if (response != null) {
        loading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){
            driverFriendListData = response;
            notifyListeners();
          }
        } else if (response.status == "fail") {

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



}