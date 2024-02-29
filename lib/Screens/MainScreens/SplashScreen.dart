import 'dart:async';
import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/BottomNavigationBar.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/userPfofilePage.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/SelectorPage.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/flutter_local_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final bool _isVisible = true;
  String isAdmin = 'false';

  bool _isloadingcomplete = false;
  var isNetwork;
  String? uid;

  Future<void> getAdmin() async {
    var valuee = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (valuee.exists) {
      setState(() {
        isAdmin = valuee.data()!['isAdmin'];
      });
    } else {
      setState(() {
        isAdmin = '';
      });
      // ToastMessage.showMessage('No User Found');
    }
  }

  @override
  void initState() {
    getUid();
    getAdmin();
    super.initState();

    Timer(const Duration(seconds: 5), () async {
      _isloadingcomplete = true;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: uid != null
              ? (isAdmin == 'true'
                  ? (context, animation, secondaryAnimation) =>
                      const ProfilePage()
                  : isAdmin == 'false'
                      ? (context, animation, secondaryAnimation) =>
                          const BottomNavBar()
                      : (context, animation, secondaryAnimation) =>
                          const SelectorPage())
              : (context, animation, secondaryAnimation) =>
                  const SelectorPage(),
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
              alignment: Alignment.bottomCenter,
              scale: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  void getUid() async {
    var data = await FlutterSecureData.getUserUid();
    setState(() {
      uid = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _splashScreen();
  }

  Widget _splashScreen() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: CustomColors.appColor,
          ),
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0,
            duration: const Duration(milliseconds: 1200),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image.asset(
                      "assets/icons/AutoSale Nepal-logos_transparent.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
