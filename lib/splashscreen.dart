import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes_app/admin/home.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/user/user_home_page.dart';

class SplashSCreen extends StatefulWidget {
  const SplashSCreen({super.key});

  @override
  State<SplashSCreen> createState() => _SplashSCreenState();
}

class _SplashSCreenState extends State<SplashSCreen> {
  bool isuserloggedin = false;
  bool isadmin = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset(
            //     "assets/images/logo.png",
            //     height: 200,
            //   ),
            // ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    final List<dynamic> _ = await Future.wait([
      _getAuthCredentials(),
    ]);
  }

  Future<void> _getAuthCredentials() async {
    final _helper = Helper();

    final result = await _helper.isUsersigned();
    if (result == true) {
      final usercred = await _helper.getUserCredentials();
      print("userlogin email : ${usercred!.email}");
      // setState(() {
      //   print("userlogin status : ${result}");
      //   isuserloggedin = result;
      // });
      //check admin
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: usercred.email)
          .where('isAdmin', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => UserHomaPage()),
            (route) => false);
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }
  }
}
