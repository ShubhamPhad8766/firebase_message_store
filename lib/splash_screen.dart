import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:message_app/message_data_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AddData(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.blueGrey),
          child: Center(
            child: Lottie.asset('assets/msg.json', height: 200, width: 200),
          ),
        ),
      ),
    );
  }
}
