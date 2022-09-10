import 'dart:io';

import 'package:Sweeper/Modal/AllCardListrPoJo.dart';
import 'package:Sweeper/Modal/SubscriptionPlanPojo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanProvider extends ChangeNotifier{
  
  var subscriptionPlansData = SubscriptionPlanPoJo();
  var allCardsData = AllCardListPoJo();
  bool loading = false;
  bool allCardLoading = false;

  //================ Subscription List
  void subscriptionPlan(BuildContext context) async{
    try {
      loading = false;
      notifyListeners();
      var response = await ApiServices.subscriptionPlanApi(context);
      if (response != null) {
        loading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){
            subscriptionPlansData = response;
            await CustomPreferences.setPreferences(PrefKeys.subscription, "premium");
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

  //=============== Add Card
  void addCard(BuildContext context, String cardToken) async{
    try {
      var response = await ApiServices.addCardApi(context, cardToken);
      if (response != null) {
        if (response.status == "success") {
         allCardLoading = false;
          notifyListeners();
          if(response.data !=null){
           allCardList(context);
            Common.hideLoading(context);
            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.hideLoading(context);
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  int isSelectedCard = -1;
  String? cardId;

  void selectCard(int i) {
    isSelectedCard = i;
    cardId = allCardsData.data!.data![i].id.toString();
    notifyListeners();
    print(cardId);
  }

  //================ All Card List
  void allCardList(BuildContext context) async{
    try {
      allCardLoading = false;
      notifyListeners();
      var response = await ApiServices.allCardListApi(context);
      if (response != null) {
        allCardLoading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null && response.data!.data !=null && response.data!.data!.length > 0){
            allCardsData = response;
            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        allCardLoading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      allCardLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      allCardLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  //=============== Delete Card
  void deleteCard(BuildContext context, String cardId) async{
    try {
      var response = await ApiServices.deleteCardApi(context, cardId);
      if (response != null) {
        if (response.status == "success") {

        } else if (response.status == "fail") {
          Common.hideLoading(context);
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }


  void payment(BuildContext context, String cardToken, String newType, String planId) async{
    try {
      Common.showLoading(context);
      var response = await ApiServices.paymentApi(context, cardToken, newType, planId);
      if (response != null) {
        if (response.status == "success") {
          Common.hideLoading(context);
          Common.showSnackBar(response.message.toString(), context, Colors.black);
          Navigator.pop(context);
        } else if (response.status == "fail") {
          Common.hideLoading(context);
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }


  int isSelectedValue = 0;
  int selectedPlanId = 0;
  
  void selectPlan(int i)
  {
    isSelectedValue = i;
    selectedPlanId = subscriptionPlansData.data![i].id as int;
    notifyListeners();
    print("Selected Driver ID: " + selectedPlanId.toString());
  }
  
}