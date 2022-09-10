import 'dart:io';
import 'package:Sweeper/Modal/Routes.dart';
import 'package:Sweeper/ProviderClass/DriverFriendsProvider.dart';
import 'package:Sweeper/screens/map/Driver_list.dart';
import 'package:Sweeper/screens/splash.dart';
import 'package:Sweeper/widgets/pushNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:provider/provider.dart';
import 'ProviderClass/AdsProvider.dart';
import 'ProviderClass/DriverRequestProvider.dart';
import 'ProviderClass/GetLocation.dart';
import 'ProviderClass/NearDriverListProv.dart';
import 'ProviderClass/NotificationProvider.dart';
import 'ProviderClass/RouteActiveInactiveProvder.dart';
import 'ProviderClass/SubscriptionProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //Get the token
  if (Platform.isIOS) {
    await Firebase.initializeApp();
    String? token = await _firebaseMessaging.getToken();
    await CustomPreferences.setPreferences("deviceID", token!);
    print("Firebase Id: "+ token);
  } else {
    await Firebase.initializeApp();
    String? token = await _firebaseMessaging.getToken();
    await CustomPreferences.setPreferences("deviceID", token!);
    print("Firebase Id: "+ token);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  String loginStatus =
  await CustomPreferences.getPreferences(PrefKeys.loginStatus);
  await ApiServices.getId();
  var uniqueID = await CustomPreferences.getPreferences(PrefKeys.deviceUniqueId);
  var roleType = await CustomPreferences.getPreferences(PrefKeys.roleType);
  print(uniqueID != null ? "unique id: " + uniqueID : "");
  runApp(MyApp(
      loginWidget: SplashScreen(
        roleType: roleType,
        screenStatus: loginStatus == "Yes"
        ? "Home"
        : "Login",
      )));
}

class MyApp extends StatefulWidget {
  var loginWidget;

  MyApp({this.loginWidget});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotificationService ? _pushNotification_Service;
  GlobalKey<NavigatorState> _navStateKey = GlobalKey<NavigatorState>();
  @override
  @override
  void initState() {
    _pushNotification_Service = PushNotificationService();
    _pushNotification_Service!.init(navigatorState: _navStateKey);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;

      AndroidNotification? android = message.notification?.android;
      String action = message.data['click_action'];

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                icon: 'launch_background',
              ),
            ),
            payload: action);
      }
      var parsedJson = message.data['type'];
      if (parsedJson == 'MATCH') {

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      var parsedJson = message.data['type'];

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserAuthProvider()),
        ChangeNotifierProvider.value(value: GetLocation()),
        ChangeNotifierProvider.value(value: NearDriverListProv()),
        ChangeNotifierProvider.value(value: Routes()),
        ChangeNotifierProvider.value(value: Driverlist()),
        ChangeNotifierProvider.value(value: DriverFriendsProvider()),
        ChangeNotifierProvider.value(value: DriverRequestProvider()),
        ChangeNotifierProvider.value(value: RouteNotificationProvider()),
        ChangeNotifierProvider.value(value: SubscriptionPlanProvider()),
        ChangeNotifierProvider.value(value: RouteActiveInActiveProvider()),
        ChangeNotifierProvider.value(value: AdsProvider()),
      ],
      child: MaterialApp(
        title: 'Sweeper',
        debugShowCheckedModeBanner: false,
        home: widget.loginWidget,
      ),
    );
  }
}
