import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/Notification/FirreBaseMessaging.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:malazgirt/Pages/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotificatinService().initNof();
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      wait = true;
    });
    await UserPrefs.getuserlogged().then((value) {
      if (value != null) {
        setState(() {
          girdi = value;
        });
      } else {
        setState(() {
          girdi = false;
        });
      }
    });
    setState(() {
      wait = false;
    });
  }

  bool wait = true;
  bool girdi = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: wait
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )
          : girdi
              ? const Home()
              : const Register(),
      debugShowCheckedModeBanner: false,
    );
  }
}
