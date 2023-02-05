import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../shared/applicant_preferences.dart';
import '../chat/chats_page.dart';
import '../profile/profile_page.dart';
import '../home/home_page.dart';
import '../liked/liked_page.dart';

class BottomTabBar extends StatefulWidget {
  int currentIndex;
  BottomTabBar({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static List<Widget> _widgetOptions = <Widget>[];
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  void initState() {
    super.initState();
    _widgetOptions = [
      HomePage(),
      LikedPage(),
      ChatsPage(),
      ProfilePage(),
    ];
    notificationTopic();
    initInfo();
  }

  Future notificationTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic(
        Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString());
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings("@drawable/notification_logo");
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => BottomTabBar(
                        currentIndex: 2,
                      )),
              (route) => false);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'tagent',
        'tagent',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Iconsax.note,
        color: AppColor.white,
      ),
      Icon(
        Icons.thumb_up_alt_outlined,
        color: AppColor.white,
      ),
      Icon(
        Icons.chat_bubble_outline,
        color: AppColor.white,
      ),
      Icon(
        Icons.person_outlined,
        color: AppColor.white,
      )
    ];
    return SafeArea(
      top: false,
      child: ClipRect(
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColor.black,
          body: Center(
            child: _widgetOptions.elementAt(widget.currentIndex),
          ),
          bottomNavigationBar: CurvedNavigationBar(
              key: navigationKey,
              color: AppColor.black,
              buttonBackgroundColor: AppColor.black,
              backgroundColor: Colors.transparent,
              height: 6.h,
              index: widget.currentIndex,
              items: items,
              onTap: (index) {
                setState(() {
                  widget.currentIndex = index;
                });
              }),
        ),
      ),
    );
  }
}
