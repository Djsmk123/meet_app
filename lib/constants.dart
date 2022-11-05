
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
var role = "";
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    playSound: true);


class ColorsSeeds{
  static Color kPrimaryColor=const Color(0XFFED4363);
  static Color kSecondaryColor=const Color(0XFF8769FD);
  static Color kPrimaryColorDark=const Color(0XFF053749);
  static Color kBlackColor=const Color(0XFF4B4B4B);
  static Color kGreyColor=const Color(0XFF949494);
}

const tagline="Connect\nwith\nFellowMate!";
const appName="MeetWithFellowMate";