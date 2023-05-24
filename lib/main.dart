import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/admin/home.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/home_screen.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/blockchain_services.dart';
import 'package:notes_app/splashscreen.dart';
import 'package:notes_app/user/signup.dart';
import 'package:notes_app/user/user_home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Future.delayed(Duration(seconds: 2));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => BlockchainServices(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _helper = Helper();

  bool isuserloggedin = false;
  bool isadmin = false;

  @override
  void initState() {
    // TODO: implement initState
    // init();
    checkpermission();
    super.initState();
  }

  void checkpermission() async {
    var status = await Permission.storage.status.isGranted;
    if (!status) {
      await Permission.storage.request();
    }
  }

  void init() async {
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
        setState(() {
          print("user is a admin");
          isuserloggedin = result;

          isadmin = true;
        });
      } else {
        setState(() {
          print("user is a not admin");
          isuserloggedin = result;
          isadmin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Add Voter',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashSCreen());
  }
}
