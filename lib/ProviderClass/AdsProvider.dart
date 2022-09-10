import 'dart:async';
import 'dart:io';
import 'package:Sweeper/Modal/AdsPoJo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/screens/adsscreen.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class AdsProvider extends ChangeNotifier{

  var adsData = AdsPoJo();
  bool loading = false;
  static const countdownDuration = Duration(seconds: 10);
  Duration duration = Duration();
  Timer? timer;
  Timer? adsTimer;
  bool? enableButton = false;

  int closeTime = -1;
  bool countDown =true;

  int start = 7;
  void adsCloseTimer(BuildContext context) {
    const oneSec = const Duration(seconds: 1);
    adsTimer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          timer.cancel();
          notifyListeners();
        } else {
          start--;
          notifyListeners();
          print("Ads Close Time: "+ start.toString());
        }
      },
    );
  }

  void reset(BuildContext context){
    if (countDown){
      duration = countdownDuration;
      notifyListeners();
    } else{
      duration = Duration();
      notifyListeners();
    }
  }

  void startTimer(BuildContext context){
    timer = Timer.periodic(Duration(seconds: 1),(_) => addTime(context));
    notifyListeners();
  }

  void adsStartTimer(BuildContext context)async{
    String getSubs = await CustomPreferences.getPreferences(PrefKeys.subscription);
    if(getSubs == "basic"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdsScreen()));
      adsCloseTimer(context);
    }
  }



  void addTime(BuildContext context){
    final addSeconds = countDown ? -1 : 1;
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0){
        timer?.cancel();
        notifyListeners();
      } else{
        duration = Duration(seconds: seconds);
        notifyListeners();
      }
    print("Time: " + duration.inSeconds.toString());
    duration.inSeconds == 1
        ? adsStartTimer(context)
        : SizedBox();
  }




  ///********** Ads *************///
  void ads(
      BuildContext context) async {
    try {
      var response =
      await ApiServices.adsApi(context);
      if (response != null) {
        loading = true;
        notifyListeners();
        if (response.status == "success") {
          adsData = response;
          notifyListeners();
        } else if (response.status == "fail") {
          Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
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





}