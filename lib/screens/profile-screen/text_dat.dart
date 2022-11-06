import 'package:flutter/material.dart';

class TextData extends StatelessWidget {

  final String text1;
  final String text2;
  const TextData({super.key, required this.text1,required this.text2,});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(text1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 15,top: 10),
          child: Text(text2,
            style: const TextStyle(
              fontSize: 20,

            ),
          ),
        ),



      ],
    );



  }
}