
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../constants.dart';
import '../providers/form_error.dart';
import 'FadeAnimation.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType1;
  final String errorKey;
  final bool isPassword;
  final String label;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.onChanged,
    required this.validator,
    required this.keyboardType1,
    required this.errorKey,
    required this.isPassword, required this.label,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool isVisiblePass = true;
  var error = "";
  var periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  hideError() async {
    periodicTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (error != "") {
        Provider.of<FormErrorModel>(context, listen: false)
            .hideFormErrors(widget.errorKey);
      }
    });
  }

  @override
  initState() {
    super.initState();
    hideError();
  }

  @override
  void dispose() {
    super.dispose();
    periodicTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    error = Provider.of<FormErrorModel>(context).getFormError(widget.errorKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(widget.label,style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ColorsSeeds.kBlackColor,
          ),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            onChanged: widget.onChanged,
            validator: widget.validator,
            keyboardType: widget.keyboardType1,
            cursorColor: ColorsSeeds.kPrimaryColor,
            obscureText: !widget.isPassword ? false : isVisiblePass,
            decoration: InputDecoration(
              errorMaxLines: null,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: ColorsSeeds.kBlackColor,width: 1),
              ),
              errorStyle: const TextStyle(
                fontSize: 0,
                color: Colors.white
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: ColorsSeeds.kGreyColor,width: 1)
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: ColorsSeeds.kBlackColor,width: 1)
              ),
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: ColorsSeeds.kPrimaryColor,width:1)
    ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisiblePass = !isVisiblePass;
                    });
                  },
                  icon: isVisiblePass
                      ?  Icon(
                    Icons.visibility_off,
                    color: ColorsSeeds.kPrimaryColor,
                  )
                      :  Icon(
                    Icons.visibility,
                    color: ColorsSeeds.kPrimaryColor,
                  ))
                  : const Text(""),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: ColorsSeeds.kGreyColor.withOpacity(0.3)
              )
            ),
          ),
        ),
        const SizedBox(height: 10,),
        if (error != "")
          Container(
            width: size.width * 0.8,
           padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeAnimation(
                0.5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: ListTile(
                            leading: const Icon(Icons.error_outline,
                                color: Colors.red),
                            horizontalTitleGap: 0,
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              error.toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ))),
                  ],
                )),
          ),
      ],
    );
  }
}
