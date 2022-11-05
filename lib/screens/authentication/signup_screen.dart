// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_app/screens/forms/member_form.dart';
import 'package:meet_app/screens/forms/user_form.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../components/FadeAnimation.dart';
import '../../components/already_have_an_account_acheck.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../constants.dart';
import '../../models/collection.dart';
import '../../providers/form_error.dart';
import '../../services/logins_signup_services.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key,}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(

      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key,}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  int index=0;
  String? email;
  FormErrorModel errorModel = FormErrorModel();
  String? password;
  final notifToken = FirebaseMessaging.instance;
  final authServices = Authentication();
  var isLoading = false;
  bool isUser=true;
  @override
  initState() {
    super.initState();
    if (mounted) {
      Provider.of<FormErrorModel>(context, listen: false).resetErrors();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const AppLogoWithNameWidget(),
                SizedBox(height: size.height * 0.03),
                FadeAnimation(
                  1.5,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Text(
                      "Sign Up",

                      style: TextStyle(
                        color: ColorsSeeds.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  1.5,
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          " Select Role ",
                          style: TextStyle(color: ColorsSeeds.kBlackColor, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ToggleSwitch(
                          minWidth: 120,
                          minHeight: 35,
                          initialLabelIndex: index,
                          cornerRadius: 10,
                          activeFgColor: Colors.white,
                          inactiveBgColor: ColorsSeeds.kGreyColor,
                          totalSwitches: 2,
                          labels: const ['Individual', 'Organization'],
                          activeBgColor: [
                            ColorsSeeds.kPrimaryColor,
                            ColorsSeeds.kPrimaryColor
                          ],
                          customTextStyles: const [
                            TextStyle(
                                color: Colors.white,
                                fontSize: 14),
                            TextStyle(
                                color: Colors.white,
                                fontSize: 14),
                          ],
                          onToggle: (int? i) {

                            index=i!;
                            isUser=i==0;

                            setState(() {

                            });

                            log(index.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                FadeAnimation(
                  1.8,
                  RoundedInputField(
                    hintText: "example@gmail.com",
                    errorKey: 'email',
                    label: "Email",
                    isPassword: false,
                    keyboardType1: TextInputType.emailAddress,
                    validator: (value) {
                      var message = "";
                      if (value!.isEmpty) {
                        message = "Email can't be empty.";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("email", message);
                        return message;
                      } else if (!(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))) {
                        message = "Enter a valid email";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("email", message);
                        return message;
                      }
                      Provider.of<FormErrorModel>(context, listen: false)
                          .setFormError("email", message);
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                FadeAnimation(
                  1.8,
                  RoundedInputField(
                    icon: Icons.lock,
                    keyboardType1: TextInputType.visiblePassword,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      var message = "";
                      if (value!.isEmpty) {
                        message = "Password can't be empty.";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("pass", message);
                        return message;
                      } else if (value.length < 8) {
                        message = "Weak Password";
                        Provider.of<FormErrorModel>(context, listen: false)
                            .setFormError("pass", message);
                        return message;
                      }
                      Provider.of<FormErrorModel>(context, listen: false)
                          .setFormError("pass", message);
                      return null;
                    },
                    errorKey: 'pass',
                    isPassword: true,
                    hintText: '*******', label: 'Password',
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Center(
                  child: FadeAnimation(
                    2,
                    RoundedButton(
                      text: "SIGN UP",
                      isLoading: isLoading,
                      color: ColorsSeeds.kPrimaryColor,
                      press: !isLoading ? onSubmit : () {

                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                FadeAnimation(
                  2,
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const LoginScreen()));
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  final Collections collections = Collections();
  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate() &&
        email!.isNotEmpty &&
        password!.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await authServices.signUp(email: email!, password: password!).then((value) async {
        String? token;
        token = await notifToken.getToken();
        await FirebaseFirestore.instance.collection('users').doc(Collections().user!.uid).set({
          'role': index == 0 ?'u':'0',
          'token': token,
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
          authServices.collections.user!.delete();
        });
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>(index==1?const MemberForm():const UserForms())));

      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: error.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM_LEFT,
            timeInSecForIosWeb: 5);
      });
      setState(() {
        isLoading = false;
      });
    }
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          /*Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/main_bottom.png",
                width: isWeb(size) ? 0 : size.width * 0.3
            ),
          ),*/
          child,
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: ColorsSeeds.kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}


