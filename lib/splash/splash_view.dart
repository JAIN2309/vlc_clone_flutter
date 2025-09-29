import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1100), () {
      Get.offNamed(Routes.HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icon.png', width: 140, height: 140),
            SizedBox(height: 20),
            Text('VividPlay', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Browse files • Play media • Background audio', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
