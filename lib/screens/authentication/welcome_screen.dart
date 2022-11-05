// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_app/constants.dart';
import 'package:meet_app/gen/assets.gen.dart';
import 'package:meet_app/screens/authentication/signup_screen.dart';

import 'package:meet_app/screens/forms/member_form.dart';
import 'package:meet_app/screens/forms/user_form.dart';
import 'package:meet_app/screens/organization_screen/organization_home_screen.dart';
import 'package:meet_app/screens/users-screens/user_home_screen.dart';

import '../../components/CustomProgressIndicator.dart';
import '../../components/rounded_button.dart';
import '../../services/custom_exception_handler.dart';
import '../../services/logins_signup_services.dart';
import 'login_screen.dart';




class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool? isLoading = true;
  final auth = FirebaseAuth.instance;
  final service = Authentication();
  bool isInitComplete = false;
  @override
  void initState() {
    super.initState();
    initLoad().then((value) {
      setState(() {
        isInitComplete = true;
        init();
      });
    });
  }

  Future<bool> initLoad() async {
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    return true;
  }

  navigator() async {
    try{
      var doc=await service.collections.userType.doc(auth.currentUser!.uid).get();
      role=doc.get('role');
      await Future.delayed(const Duration(seconds: 1));
      switch(role)
      {
       case 'u': {

         var vol=await service.collections.userData.doc(auth.currentUser!.uid).get();
         Navigator.pop(context);
         if(vol.exists) {
           Navigator.push(context, MaterialPageRoute(builder: (builder)=>const UserHomeScreen()));
         }
         else{
           Navigator.push(context, MaterialPageRoute(builder: (builder)=>const UserForms()));
         }
         break;
       }
         case 'o':{
           var vol=await service.collections.org.doc(auth.currentUser!.uid).get();
           Navigator.pop(context);
           if(vol.exists) {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>const OrgHomeScreen()));
           }
           else{
             Navigator.push(context, MaterialPageRoute(builder: (builder)=>const MemberForm()));
           }
       break;
        }

      }

    }
    catch(error){
      FirebaseAuth.instance.signOut();
      if (error.runtimeType == CustomExceptionHandler) {
        FirebaseAuth.instance.signOut();
      } else {
        Fluttertoast.showToast(msg: "Error while loading data");
      }

    }

  }

  Future<void> init() async {
      if (isInitComplete) {
        foregroundNotification();
      }
    User? user = await getFirebaseUser();
    if (user != null && isInitComplete) {
      navigator();
    } else {
      if (isInitComplete) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Image.asset(
            Assets.images.appLogo.path,
          ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:60),
              child: Text(tagline,
                style: TextStyle(
                color: ColorsSeeds.kBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),),
            ),
          ],
        ),
      ),
       if (isLoading != null)
         if (isLoading!)
           const Center(
             child: CustomProgressIndicator(),
           ),
       SizedBox(height: size.height * 0.05),
       if (isLoading != null)
         if (!isLoading!)
           Center(
             child: RoundedButton(
               text: "LOGIN",
               color: ColorsSeeds.kPrimaryColor,
               press: () {
                 Navigator.push(context, MaterialPageRoute(builder: (builder)=>const LoginScreen()));
               },
             ),
           ),
       const SizedBox(height: 20),
       if (isLoading != null)
         if (!isLoading! && !kIsWeb)
           Center(
             child: RoundedButton(
               text: "SIGN UP",
               color:ColorsSeeds.kSecondaryColor,
               textColor: Colors.white,
               press: () {
                 Navigator.push(context, MaterialPageRoute(builder: (builder)=>const SignUpScreen()));
               },
             ),
           ),
     ],
   );
  }
}



Future getFirebaseUser() async {
  var auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    return auth.authStateChanges().first;
  }
  return auth.currentUser;
}
Future<void> onBackgroundMessage(RemoteMessage message) async {
  debugPrint("BackgroundNotificationHandler");
}
FlutterLocalNotificationsPlugin fltNotification =FlutterLocalNotificationsPlugin();
final notification = FirebaseMessaging.instance;
void foregroundNotification() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    RemoteNotification? notification = event.notification;
    AndroidNotification? android = event.notification?.android;
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    fltNotification.initialize(initializationSettings);
    if (notification != null && android != null) {
      fltNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });
}