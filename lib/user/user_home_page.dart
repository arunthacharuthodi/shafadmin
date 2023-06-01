import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes_app/admin/result.dart';
import 'package:notes_app/admin/see_all_voters.dart';
import 'package:notes_app/config/color.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/helper/firestore.dart';
import 'package:notes_app/helper/location.dart';
import 'package:notes_app/user/candidate.dart';
import 'package:notes_app/user/history.dart';
import 'package:notes_app/user/signup.dart';

import 'package:notes_app/user/vote_now.dart';

class UserHomaPage extends StatefulWidget {
  const UserHomaPage({super.key});

  @override
  State<UserHomaPage> createState() => _UserHomaPageState();
}

class _UserHomaPageState extends State<UserHomaPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateDoctorLocation();
  }

  Future<void> _updateDoctorLocation() async {
    final _locationService = LocationServices();
    _locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorCOnfig().secondary,
        appBar: AppBar(
          backgroundColor: ColorCOnfig().secondary,
          title: const Text(
            "Home page",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DrawerHeader(
                  child: Text("admin app of doctor registration 1.1"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final _helper = Helper();
                              await _helper.firebaseSignout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                  (route) => false);
                            } on FirebaseException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message!)));
                            }
                          },
                          child: Text("Logout"))),
                )
              ],
            ),
          ),
        ),
        // show card?
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20.0),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: .8,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const VoteNow()));
              },
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookingHistory())),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5)
                      ]),
                  height: 20,
                  // color: Colors.red,
                  child: Center(child: Text(' Appoinments')),
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const Result(
            //                   isAdmin: false,
            //                 )));
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(20),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 10,
            //               spreadRadius: 5)
            //         ]),
            //     height: 20,
            //     // color: Colors.red,
            //     child: Center(child: Text('Result')),
            //   ),
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const CommingSoon()));
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(20),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 10,
            //               spreadRadius: 5)
            //         ]),
            //     height: 20,
            //     // color: Colors.red,
            //     child: Center(child: Text('See Candidate details')),
            //   ),
            // ),
          ],
        ));
  }
}
