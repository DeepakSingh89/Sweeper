import 'dart:io';
import 'package:Sweeper/Modal/CityPoJo.dart';
import 'package:Sweeper/Modal/PrivacyPolicyPoJo.dart';
import 'package:Sweeper/Modal/TermAndConditionPoJo.dart';
import 'package:Sweeper/ProviderClass/GetLocation.dart';
import 'package:Sweeper/screens/ForgotChangePass.dart';
import 'package:Sweeper/screens/LoginOtpVerify.dart';
import 'package:Sweeper/screens/map/homeMap.dart';
import 'package:Sweeper/screens/map/locationAccess.dart';
import 'package:Sweeper/screens/map/starttrip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/Modal/ProfilePoJo.dart';
import 'package:Sweeper/Modal/UserAuthPoJo.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/screens/auth/login.dart';
import 'package:Sweeper/screens/createProfile.dart';
import 'package:Sweeper/screens/twoStepVerify.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:provider/provider.dart';


class UserAuthProvider extends ChangeNotifier {
  var loginData = UserAuthPoJo();
  var profileData = ProfilePoJo();

  var privacyPolicyData = PrivacyPolicyPoJo();
  var termAndConditionData = TermAndConditionPoJo();

  var cityListData = CityListPoJo();

  bool privacyLoading = false;
  bool termsLoading = false;
  bool cityListLoading = false;

  bool notificationOnOff = false;

  bool loading = false;

  String? status;


  Future<bool?> getNotificationOnOff() async{
   String getValue = await CustomPreferences.getPreferences(PrefKeys.isNotification);
    if (getValue == "1") {
      notificationOnOff = true;
      notifyListeners();
    } else {
      notificationOnOff = false;
      notifyListeners();
    }
  }

  ///*************** Notification On Off Api *************///
  void notificationOnOf(String status, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.notificationOnOffApi(context, status);
      if (response != null) {
        Common.hideLoading(context);
        if (response.status == true) {
          if(response.userInfo!.notificationStatus == "1"){
            notificationOnOff = true;
            notifyListeners();
            await CustomPreferences.setPreferences(PrefKeys.isNotification, "1");
          }else if(response.userInfo!.notificationStatus == "0"){
            notificationOnOff = false;
            notifyListeners();
            await CustomPreferences.setPreferences(PrefKeys.isNotification, "0");
          }
          Common.showSnackBar(response.message.toString(), context, Colors.black);
        } else if (response.status == false) {
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

  ///********** Privacy Policy *************///
  void privacyPolicy(BuildContext context) async {
    try {
      privacyLoading = false;
      notifyListeners();
      var response = await ApiServices.privacyPolicyApi(context);
      if (response != null) {
        privacyLoading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){
            privacyPolicyData = response;
            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        privacyLoading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      privacyLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      privacyLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********** Term & Condition *************///
  void termAndCondition(BuildContext context) async {
    try {
      termsLoading = false;
      notifyListeners();
      var response = await ApiServices.termAndConditionApi(context);
      if (response != null) {
        termsLoading = true;
        notifyListeners();
        if (response.status == "success") {
          if(response.data !=null){
            termAndConditionData = response;
            notifyListeners();
          }
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        termsLoading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      termsLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      termsLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********** City *************///
  void cityList(BuildContext context) async {
    try {
      cityListLoading = false;
      notifyListeners();
      var response = await ApiServices.cityListApi(context);
      if (response != null) {
        cityListLoading = true;
        notifyListeners();
        if (response.status == true) {
          if(response.data !=null){
            cityListData = response;
            notifyListeners();
          }
        } else if (response.status == false) {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        cityListLoading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      cityListLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      cityListLoading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********** Register *************///
  void register(String name, String email, String password, String number,
      BuildContext context, String roleType) async {
    try {
      Common.showLoading(context);
      var response =
      await ApiServices.registerApi(name, email, password, number, context, roleType);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          await CustomPreferences.setPreferences(PrefKeys.saveName, name.toString());
          if (response['token'] != null) {
            await CustomPreferences.setPreferences(PrefKeys.loginToken, response['token'].toString());
            await CustomPreferences.setPreferences(PrefKeys.roleType, roleType.toString());
            await CustomPreferences.setPreferences(PrefKeys.subscription, response['data']['subscription'].toString());
          }
          registerSuccessPopup(
              context,
              "Otp has been sent on your register email address. Please check your mail box.",
              email);
        } else if (response['status'] == false) {
          Common.showSnackBar(response['message'].toString(), context, Colors.red);
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

  ///********** Login *************///
  void login(String email, String password, BuildContext context, String roleType) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.loginApi(email, password, context, roleType);
      if 
      (response != null) {
        Common.hideLoading(context);
        if (response.status == true) {
          if (response.token != null) {
            await CustomPreferences.setPreferences(
                PrefKeys.loginToken, response.token.toString());
            await CustomPreferences.setPreferences(PrefKeys.roleType, response.role.toString());
            await CustomPreferences.setPreferences(PrefKeys.isNotification, response.userInfo!.notificationStatus.toString());
            await CustomPreferences.setPreferences(PrefKeys.subscription, response.userInfo!.subscription.toString());
            }
          if (response.userInfo!.isEmailVerified == null) {
            notVerifyPopUp(context, "Email address is not verified. Please verify.", email);
          }
          else if (response.rememberDevice == false) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginOtpVerify(
                  email: email.toString(),
                  popupStatus: 1,
                )),
                    (Route<dynamic> route) => false);
          } else {
            await CustomPreferences.setPreferences(PrefKeys.loginStatus, "Yes");
            if(response.userInfo!.profilePic!.endsWith('placeholder.png')){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(
                    roleType: response.role.toString(),
                  )),
                      (Route<dynamic> route) => false);
            }
            else {
              response.role.toString() == "3"
                  ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartTrip()),
                      (Route<dynamic> route) => false)
                  : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
            }
            Common.showSnackBar(
                ConstantsText.loginSuccess, context, Colors.black);
          }
        } else if (response.status == false) {
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

  ///******** Get User Data *********///
  Future<void> getUserData() async {
    var userData = await CustomPreferences.read(PrefKeys.loginData);
    loginData = UserAuthPoJo.fromJson(userData);
    notifyListeners();
  }

  ///********** 2 step verify *************///
  void twoStepVerify(String otp, BuildContext context, String rememberMe) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.twoStepVerifyApi(otp, context, rememberMe);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          String roleType = await CustomPreferences.getPreferences(PrefKeys.roleType);
          await CustomPreferences.setPreferences(PrefKeys.loginStatus, "Yes");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Profile(
                roleType: roleType,
              )),
                  (Route<dynamic> route) => false);
          Common.showSnackBar(
              response['message'].toString(), context, Colors.black);
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        } else if (response['status'] == false) {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
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


  ///********** login otp verify *************///
  void loginOtpVerify(String otp, BuildContext context, String rememberMe) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.twoStepVerifyApi(otp, context, rememberMe);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          String roleType =  await CustomPreferences.getPreferences(PrefKeys.roleType);
          await CustomPreferences.setPreferences(PrefKeys.loginStatus, "Yes");
          if (Provider.of<GetLocation>(context, listen: false).locationData == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LocationAccess(
                  roleType: roleType,
                )),
                    (Route<dynamic> route) => false);
          }
          else{
            roleType == "3"
                ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StartTrip()),
                    (Route<dynamic> route) => false)
                : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false);
          }
          Common.showSnackBar(
              response['message'].toString(), context, Colors.black);
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        } else if (response['status'] == false) {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
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


  ///********** Resend Otp *************///
  void resendOtp(String email, BuildContext context) async {
    try {
      var response = await ApiServices.resendOtpApi(email, context);
      if (response != null) {
        if(response['status'] == true) {
        } else if (response['status'] == 'success') {
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        } else if (response['status'] == false) {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        }
      } else {
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********** Logout *************///
  void logout(BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.logoutApi(context);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          String cityName = await CustomPreferences.getPreferences(PrefKeys.createProfilePage);
          String deviceUniqueId = await CustomPreferences.getPreferences(PrefKeys.deviceUniqueId);
          CustomPreferences.clearAll().then((_) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false);
          });
          await CustomPreferences.setPreferences(PrefKeys.createProfilePage, "Yes");
          await CustomPreferences.setPreferences(PrefKeys.createProfilePage, "Yes");
          await CustomPreferences.setPreferences(PrefKeys.cityName, cityName.toString());
          await CustomPreferences.setPreferences(PrefKeys.deviceUniqueId, deviceUniqueId.toString());
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        } else if (response['status'] == false) {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
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

  ///********** Change Password *************///
  void changePassword(String oldPassword,
      String newPassword, String confirmNew, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.changePasswordApi(oldPassword,
          newPassword, confirmNew, context);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          Common.showSnackBar(response['message'].toString(), context, Colors.black);
          Navigator.pop(context);
        } else if (response['status'] == false) {
          Common.showSnackBar(response['message'], context, Colors.red);
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

  ///********** Forgot Send Code *************///
  void forgotSendCode(String email, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.forgotSendCodeApi(email, context);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          _forgotSendCodePopUp(
              context,
              'Send OTP',
              'Otp sent to your register email address. Please check mail box.',
              'Ok');
        } else if (response['status'] == 'success') {
          _forgotSendCodePopUp(
              context,
              'Send OTP',
              'Otp sent to your register email address. Please check mail box.',
              'Ok');
        } else if (response['status'] == 'fail') {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
        } else if (response['status'] == false) {
          Common.showSnackBar(
              response['message'].toString(), context, Colors.red);
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

  ///********** Profile *************///
  void profile(
      BuildContext context, proImage, String name,  String phone, String cityName) async {
    try {
      proImage == '' ? SizedBox() : Common.showLoading(context);
      var response =
      await ApiServices.profileApi(context, proImage, name,phone, cityName);
      if (response != null) {
        proImage == '' ? SizedBox() : Common.hideLoading(context);
        loading = true;
        notifyListeners();
        if (response.status == true) {
          if (response.userInfo != null) {
            profileData = response;
            notifyListeners();
            proImage == '' ? SizedBox() : Navigator.pop(context);
          }
        } else if (response.status == false) {
          Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
        }
      } else {
        proImage == '' ? SizedBox() : Common.hideLoading(context);
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      proImage == '' ? SizedBox() : Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      proImage == '' ? SizedBox() : Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********** Create Profile *************///
  void createProfile(
      BuildContext context, proImage, String name, String cityName, String roleType) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.createProfile(context, proImage, name, cityName);
      if (response != null) {
        Common.hideLoading(context);
        loading = true;
        notifyListeners();
        if (response.status == true) {
          if (response.userInfo != null) {
            profileData = response;
            notifyListeners();
            await CustomPreferences.setPreferences(PrefKeys.cityName, cityName.toString());
            await CustomPreferences.setPreferences(PrefKeys.createProfilePage, 'Yes');
            if (Provider.of<GetLocation>(context, listen: false).locationData == null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LocationAccess(
                    roleType: roleType,
                  )),
                      (Route<dynamic> route) => false);
            }
            else{
              roleType == "3"
                  ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartTrip()),
                      (Route<dynamic> route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
            }
          }
        } else if (response.status == false) {
          Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }

  ///********* Forgot Pass
  void forgotToPass(String otp, String pass, String confirmPass, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response =
      await ApiServices.forgotToPass(otp, pass, confirmPass, context);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
          Common.showSnackBar("Password change successfully. PLease login.", context, Colors.black);
        } else if (response['status'] == false) {
          Common.showSnackBar(response['message'].toString(), context, Colors.red);
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




  notVerifyPopUp(BuildContext context, String message, String email){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TwoStepVerify(
                              email: email.toString(),
                              popupStatus: 1,
                            )));
                  },
                ),
              ),
            ],
          )
              : AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TwoStepVerify(
                            email: email.toString(),
                            popupStatus: 1,
                          )));
                },
              )
            ],
          );
        });
  }


  // Register Success Popup
  registerSuccessPopup(
      BuildContext context, String message, String email) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TwoStepVerify(
                              email: email.toString(),
                            )));
                  },
                ),
              )
            ],
          )
              : AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TwoStepVerify(
                              email: email.toString(),
                            )));
                  },
                ),
              )
            ],
          );
        });
  }

  // Forgot Send Code
  _forgotSendCodePopUp(
      BuildContext context, String title, String dis, String action) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: 170,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        dis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ForgotChangePass()));
                        },
                        child: Text(
                          action,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ));
        });
  }




  ///********** Update Location *************///
  void updateLocation(
      BuildContext context,String lat, String lng) async {
    print('======================1=${lat.toString()}');
    print('======================2=${lng.toString()}');
    try {
      Common.showLoading(context);
      var response = await ApiServices.updateLocation(context, lat, lng);
      if (response != null) {
        Common.hideLoading(context);
        loading = true;
        notifyListeners();
        if (response.status == true) {
          
        } else if (response.status == false) {
          Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }
  
}
