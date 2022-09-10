import 'dart:io';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('onBackgroundMessage');
  print('onBackgroundMessage ${message.messageId}');
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  GlobalKey<NavigatorState>? _navigatorState;

  PushNotificationService();


  Future init({required GlobalKey<NavigatorState> navigatorState}) async {
    _navigatorState = navigatorState;

    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }

    //Get the token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('firebase token $token');
      await CustomPreferences.setPreferences("deviceID", token);
    } else {
      await CustomPreferences.setPreferences("deviceID", '123');
    }

    //call when the app is in foreground mode
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage ${message.messageId}');
    });

    //call when the notification is tapped on
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('onMessageOpenedApp ${message.messageId}');
    });

    //call when the app in background mode
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }


  void navigateTo(Map<String, dynamic> message) {
    print('navigateTo $message');
    if (Platform.isIOS) {
      // showSimpleNotification(
      //     Text(
      //       message['notification'] != null ? message['body'] : '',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     duration: Duration(seconds: 2),
      //     background: Colors.black);
    } else {
      // showSimpleNotification(
      //     Text(
      //       message['notification'] != null
      //           ? message['notification']['body']
      //           : '',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     duration: Duration(seconds: 2),
      //     background: Colors.black);
    }
  }
}