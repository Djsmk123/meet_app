import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/screens/authentication/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:meet_app/providers/form_error.dart';


import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>FormErrorModel()),
      ],
      child: MaterialApp(
          theme: ThemeData(useMaterial3: true,
              scaffoldBackgroundColor: Colors.white),
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          home: const WelcomeScreen()),
    );
  }
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
Map<String,dynamic> userdata= { "name": "SmkWinner",
  "skills": [
    "C++",
    "Java",
    "Flutter",
    "Dart",
    "Firebase"
  ],
  "age": 21,
  "job_title": "Flutter Developer at xyz",
  "bio": "Experienced Flutter Developer adept in all stages of advanced Flutter development. "
      "Knowledgeable in user interface, testing, and debugging processes. Able to "
      "effectively self-manage during independent projects, as well as collaborate in a "
      "team setting.",
  "img": "https://github.com/djsmk123",
  "email": "djsmk123@gmail.com",
  "phone_number": "+91987654321",
  "profile_links": [
    {
      "label": "github",
      "url": "https://github.com/djsmk123",
      "is_visible": true,
    },
    {
      "label": "twitter",
      "url": "https://twitter.com/smk_winner",
      "is_visible": true
    }
  ]
};