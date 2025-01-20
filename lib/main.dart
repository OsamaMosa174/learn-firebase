import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/app/addcategory.dart';
import 'package:untitled/app/homepage.dart';
import 'package:untitled/auth/login.dart';
import 'package:untitled/auth/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //     options: const FirebaseOptions(
      //   apiKey: 'key',
      //   appId: 'id',
      //   messagingSenderId: 'sendid',
      //   projectId: 'myapp',
      //   storageBucket: 'myapp-b9yt18.appspot.com',
      // )
      );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('------------User is currently signed out!--------------------');
      } else {
        print('----------------User is signed in!--------------');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 236, 235, 235),
            titleTextStyle: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.orange)),
      ),
      title: 'Learn Firebase',
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage()
          : Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) => const Homepage(),
        "addcategory": (context) => const Addcategory(),
      },
    );
  }
}
