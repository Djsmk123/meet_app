// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:meet_app/constants.dart';
import 'package:meet_app/models/user_model_new.dart';
import 'package:meet_app/screens/authentication/welcome_screen.dart';


import '../gen/assets.gen.dart';
import '../screens/profile-screen/profile_screen.dart';
import '../services/logins_signup_services.dart';

class EndDrawer extends StatelessWidget {

  const EndDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn=FirebaseAuth.instance.currentUser!=null;
    return Drawer(
      //backgroundColor: kPrimaryColor,
      elevation: 10,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              maxRadius: 80,
              backgroundColor: ColorsSeeds.kPrimaryColor,
              backgroundImage:(userModel!.img!=null)?NetworkImage(userModel!.img!):Assets.images.appLogo.provider()
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    userModel!.name,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontFamily: GoogleFonts.dancingScript().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
              height: 50,
            ),
            if (!isLoggedIn)
              drawerRowWidget(
                  title: "Login",
                  icon: Icons.login,
                  onTap: () {
                    if (!isLoggedIn) {
                      Navigator.pop(context);
                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const WelcomeScreen()));
                    }
                  }),
            drawerRowWidget(
                title: "Edit Profile",
                icon: Icons.person,
                onTap: () {
                  if (!isLoggedIn) {
                    showToast(msg:"Login required");
                  }
                  else{
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfileScreen(userModel: userModel!,)));
                  }
                }),
            /*drawerRowWidget(
                title: "upload templates",
                icon: Icons.upload,
                onTap: () {
                  if (!isLoggedIn) {
                    showToast(msg:"Login required");
                  } else {
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const MemeUploadScreen()));
                  }
                }),*/
            if (isLoggedIn)
              drawerRowWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  onTap: () async {
                    await Authentication().logOut();
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const WelcomeScreen()));
                  }),
          ],
        ),
      ),
    );
  }

  Widget drawerRowWidget(
      {required String title,
        required IconData icon,
        required GestureTapCallback onTap}) {
    return Row(
      children: [
        Flexible(
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              onTap: onTap,
              horizontalTitleGap: 5,
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ))
      ],
    );
  }
}
