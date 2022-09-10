import 'dart:convert';
import 'dart:io';
import 'package:Sweeper/Modal/AcceptFriendRequestPoJo.dart';
import 'package:Sweeper/Modal/AddCardPoJo.dart';
import 'package:Sweeper/Modal/AdsPoJo.dart';
import 'package:Sweeper/Modal/AllCardListrPoJo.dart';
import 'package:Sweeper/Modal/CardDeletePoJo.dart';
import 'package:Sweeper/Modal/CityPoJo.dart';
import 'package:Sweeper/Modal/DriverFriendsListPoJo.dart';
import 'package:Sweeper/Modal/DriverRequestListPojo.dart';
import 'package:Sweeper/Modal/NearDriverPoJo.dart';
import 'package:Sweeper/Modal/PaymentPoJo.dart';
import 'package:Sweeper/Modal/PrivacyPolicyPoJo.dart';
import 'package:Sweeper/Modal/RouteActiveInactivePoJo.dart';
import 'package:Sweeper/Modal/RouteNotificationPoJo.dart';
import 'package:Sweeper/Modal/Routes.dart';
import 'package:Sweeper/Modal/SubscriptionPlanPojo.dart';
import 'package:Sweeper/Modal/SendFriendRequestPoJo.dart';
import 'package:Sweeper/Modal/TermAndConditionPoJo.dart';
import 'package:Sweeper/screens/map/Driver_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/Modal/ProfilePoJo.dart';
import 'package:Sweeper/Modal/UserAuthPoJo.dart';
import 'package:http/http.dart' as http;
import 'package:Sweeper/Network/Api_Urls.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:device_info/device_info.dart';

class ApiServices {
  ///********** Get Device Id **************///
  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      await CustomPreferences.setPreferences(
          PrefKeys.deviceUniqueId, iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      await CustomPreferences.setPreferences(
          PrefKeys.deviceUniqueId, androidDeviceInfo.androidId);

      return androidDeviceInfo.androidId;
    }
  }


  ///*************** Privacy Policy Api *************///
  static Future<PrivacyPolicyPoJo?> privacyPolicyApi(BuildContext context) async {
    String url = ApiUrls.baseUrl + ApiUrls.privacyPolicyApi;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return privacyPolicyPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Subscription Plan Api *************///
  static Future<SubscriptionPlanPoJo?> subscriptionPlanApi(BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.subscriptionPlanApi;
    var response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return subscriptionPlanPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Term & Condition Api *************///
  static Future<TermAndConditionPoJo?> termAndConditionApi(BuildContext context) async {
    String url = ApiUrls.baseUrl + ApiUrls.termsConditionsApi;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return termAndConditionPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** City List Api *************///
  static Future<CityListPoJo?> cityListApi(BuildContext context) async {
    String url = ApiUrls.baseUrl + ApiUrls.cityListApi;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return cityListPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///****************** User Login Api ******************///
  static Future<UserAuthPoJo?> loginApi(
      String emailID, String password, BuildContext context, String roleType) async {
    var uniqueID =
    await CustomPreferences.getPreferences(PrefKeys.deviceUniqueId);
    String url = ApiUrls.baseUrl + ApiUrls.loginApi;
    Map<String, dynamic> body = {
      "email": emailID,
      "password": password,
      "device_id": uniqueID,
      "role": roleType
    };
    var response = await http.post(
      Uri.parse(url),
      body: body,
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      Map<String, dynamic> res = json.decode(response.body);
      UserAuthPoJo data = UserAuthPoJo.fromJson(res);
      await CustomPreferences.save(PrefKeys.loginData, data);
      return userAuthPoJoFromJson(jsonString);
    } else if (response.statusCode == 422) {
      var jsonString = response.body;
      Map<String, dynamic> res = json.decode(response.body);
      UserAuthPoJo data = UserAuthPoJo.fromJson(res);
      await CustomPreferences.save(PrefKeys.loginData, data);
      return userAuthPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** User Register Api ******************///
  static Future<dynamic> registerApi(String name, String email, String password,
      String number, BuildContext context, String roleType) async {
    String url = ApiUrls.baseUrl + ApiUrls.signUpApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": number,
        "role": roleType
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Two Step Verify Api ******************///
  static Future<dynamic> twoStepVerifyApi(
      String otp, BuildContext context, rememberMe) async {
    var uniqueID =
    await CustomPreferences.getPreferences(PrefKeys.deviceUniqueId);
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.twoStepVerifyApi;
    Map<String, dynamic> body = {
      "otp": otp,
      "device_id": uniqueID,
      "remember_device": rememberMe
    };
    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Resend Otp Api ******************///
  static Future<dynamic> resendOtpApi(
      String email, BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.resendOtpApi;
    var response = await http.post(
      Uri.parse(url),
      body: {"email": email, "type": "registration_otp"},
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Forgot Password Send Code Api ******************///
  static Future<dynamic> forgotSendCodeApi(
      String email, BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.forgotSendCodeApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "email": email,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Change Password Api ******************///
  static Future<dynamic> changePasswordApi(String oldPassword,
      String newPassword, String confirmNew, BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.changePasswordApi;
    Map<String, dynamic> body = {
      "forget_password": "false",
      "old_password": oldPassword,
      "password": newPassword,
      "confirm_password": confirmNew,
      "otp": ""
    };
    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Logout Api ******************///
  static Future<dynamic> logoutApi(BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.logoutApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Profile Api ******************///
  static Future<ProfilePoJo?> profileApi(BuildContext context, String proImage,
      String name,String phone, String cityName) async {
    if (proImage == '' && name == ''   && cityName == '') {
      String token =
      await CustomPreferences.getPreferences(PrefKeys.loginToken);
      String url = ApiUrls.baseUrl + ApiUrls.profileApi;
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ' + token,
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return profilePoJoFromJson(jsonString);
      } else if (response.statusCode == 500) {
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      } else {
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
      return null;
    }
    else {
      String token =
      await CustomPreferences.getPreferences(PrefKeys.loginToken);
      String url = ApiUrls.baseUrl + ApiUrls.profileApi;
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ' + token,
        },
        body: {
          'name': name,
          'phone': phone,
          'profile_pic': proImage,
          'city': cityName
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        Map<String, dynamic> res = json.decode(response.body);
        return profilePoJoFromJson(jsonString);
      } else if (response.statusCode == 500) {
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      } else {
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
      return null;
    }
  }

  ///****************** Profile Api ******************///
  static Future<ProfilePoJo?> createProfile(BuildContext context,
      String proImage, String name, String cityName) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.profileApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        'name': name,
        'profile_pic': proImage,
        'city': cityName
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      Map<String, dynamic> res = json.decode(response.body);
      return profilePoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Update Location Api ******************///
  static Future<dynamic> updateLocation(BuildContext context,
      String lat, String lng) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.profileApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
       "lat": lat,
        "lng": lng
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      Map<String, dynamic> res = json.decode(response.body);
      return profilePoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///****************** Notification On Off Api ******************///
  static Future<ProfilePoJo?> notificationOnOffApi(BuildContext context,
      String status) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.profileApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "notification_status": status
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return profilePoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///****************** Forgot TO Pass Api ******************///
  static Future<dynamic> forgotToPass(
      String otp, String pass, String confirmPass, BuildContext context) async {
    String url = ApiUrls.baseUrl + ApiUrls.changePasswordApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "forget_password": "true",
        "otp": otp,
        "password": pass,
        "confirm_password": confirmPass
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///****************** Near Driver List Api ******************///
  static Future<NearDriverPoJo?> nearDriverListApi(
      String lat, String lng, BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.nearDriverListApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        'lat': lat,
        'lng': lng
      },
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return nearDriverPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  static Future<dynamic> saveRoute(
  List<Map<String,dynamic>> dataList,String routeName, BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.saveRoute;
    print(dataList.length);
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'route_name': routeName,
        'route_desc': '',
        'coordinates':dataList,
      }),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        "Content-Type" : 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> resonse=json.decode(response.body);
      return resonse;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  static Future<Routes?> getRoutes(BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.getRoutes;
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200)
    {
      Map<String,dynamic> responseData = json.decode(response.body);
      return Routes.fromJson(responseData);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///for drivers list nearby
  static Future<Driverlist?> getDriversForDriver(BuildContext context, String lat, String lng) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);

    String url = ApiUrls.baseUrl + ApiUrls.getDriverListForDriver;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "lat": lat,
        "lng": lng
      },
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200)
    {
      Map<String,dynamic> resonse = json.decode(response.body);
      return Driverlist.fromJson(resonse);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  static Future<Driverlist?> getDrivers(BuildContext context, String lat, String lng) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.getDriverList;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "lat": lat,
        "lng": lng
      },
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200)
    {
      Map<String,dynamic> resonse = json.decode(response.body);
      return Driverlist.fromJson(resonse);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Driver Friends List Api *************///
  static Future<DriverFriendsListPoJo?> driversFriendsListApi(BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.driverFriendsListApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return driverFriendsListPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Send Friend Request Api *************///
  static Future<SendFriendsRequestPoJo?> sendFriendRequestApi(String driverId,BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.sendFriendRequestApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "driver_id": driverId
      },
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return sendFriendsRequestPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Accept Friend Request Api *************///
  static Future<AcceptFriendsRequestPoJo?> acceptFriendRequestApi(String driverId,BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.acceptFriendRequestApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "driver_id": driverId
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return acceptFriendsRequestPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Driver Friends Request List Api *************///
  static Future<DriverRequestListPoJo?> driversFriendsRequestListApi(BuildContext context) async {
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.driverFriendsRequestListApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return driverRequestListPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Share Route Api *************///
  static Future<dynamic> shareRouteApi(String driverId,String routeId,String date ,BuildContext context) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.shareRouteApi;
    var response = await http.post(
      Uri.parse(url),
      body: {
        "driver_id": driverId,
        "route_id": routeId,
        "date": date,
      },
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Route Notification Api *************///
  static Future<RouteNotificationPoJo?> getRouteNotificationApi(BuildContext context) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.getRouteNotification;

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;

      return routeNotificationPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Route Accept And Reject Api *************///
  static Future<dynamic> routeAcceptAndReject(BuildContext context, String routeId, String status) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.updateRouteNotifyStatus;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "route_id": routeId,
        "action": status,
      }
    );
    if (response.statusCode == 200) {

      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Add card Api *************///
  static Future<AddCardPoJo?> addCardApi(BuildContext context, String cardToken) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.addCardApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "src_token":  cardToken
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return addCardPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** All card List Api *************///
  static Future<AllCardListPoJo?> allCardListApi(BuildContext context) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.allCardListApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return allCardListPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }


  ///*************** Delete card Api *************///
  static Future<CardDeletePoJo?> deleteCardApi(BuildContext context, String cardToken) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.cardDeleteApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "card_id":  cardToken
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return cardDeletePoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Payment Api *************///
  static Future<PaymentPoJo?> paymentApi(BuildContext context, String cardToken, String newType, String planId) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.paymentApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "subscription_id": planId,
        "new" : "0",
        "src_token": cardToken
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return paymentPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Route Active Api *************///
  static Future<RouteActiveInactivePoJo?> routeActiveApi(BuildContext context, String routeId) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.routeActiveApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "route_id": routeId,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return routeActiveInactivePoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Route InActive Api *************///
  static Future<dynamic> routeInActiveApi(BuildContext context, String routeId) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.routeInActiveApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
      body: {
        "route_id": routeId,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return responseJson;
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

  ///*************** Ads Api *************///
  static Future<AdsPoJo?> adsApi(BuildContext context) async{
    String token = await CustomPreferences.getPreferences(PrefKeys.loginToken);
    String url = ApiUrls.baseUrl + ApiUrls.adsApi;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return adsPoJoFromJson(jsonString);
    } else if (response.statusCode == 500) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    } else {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
    return null;
  }

}
