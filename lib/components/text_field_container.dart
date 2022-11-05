/*


// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
   Color? clr=ColorsSeeds.kSecondaryColor;
   TextFieldContainer(
      {Key? key, required this.child, this.clr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width * 0.8,
      alignment: Alignment.center,
      child: child,
    );
  }
}
*/
