// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/admin/add_election.dart';
import 'package:notes_app/admin/addcandidate.dart';
import 'package:notes_app/admin/result.dart';
import 'package:notes_app/admin/see_all_election.dart';
import 'package:notes_app/admin/see_all_voters.dart';
import 'package:notes_app/admin/showelections.dart';
import 'package:notes_app/blockchain_services.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/user/signup.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<BlockchainServices>();

    return Scaffold(
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DrawerHeader(
                  child: Text("Doc Admin App version 1.1"),
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
                                    builder: (context) => LoginScreen(),
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
        appBar: AppBar(
          title: const Text('Home page'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  'See all Doctor Requests',
                  style: TextStyle(
                    color: Colors.white,
                    // color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VotersList(
                            isAdmin: true,
                          )));
                },
              ),
            ),

            // Container(
            //   margin: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: ListTile(
            //     title: const Text(
            //       'Add Election',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     trailing: const Icon(
            //       Icons.arrow_forward_ios,
            //       color: Colors.white,
            //     ),
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => AddElection()));
            //     },
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: ListTile(
            //     title: const Text(
            //       'Add Candidate',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     trailing: const Icon(
            //       Icons.arrow_forward_ios,
            //       color: Colors.white,
            //     ),
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => ShowElections()));
            //     },
            //   ),
            // ),
            // // Container(
            // //   margin: const EdgeInsets.all(15),
            // //   decoration: BoxDecoration(
            // //     color: Colors.blue,
            // //     borderRadius: BorderRadius.circular(10),
            // //   ),
            // //   child: ListTile(
            // //     title: const Text('See all Elections'),
            // //     trailing: const Icon(Icons.arrow_forward_ios),
            // //     onTap: () {
            // //       Navigator.of(context).push(MaterialPageRoute(
            // //           builder: (context) => SeeAllElections()));
            // //     },
            // //   ),
            // // ),
            // Container(
            //   margin: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: ListTile(
            //     title: const Text(
            //       'Results',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     trailing: const Icon(
            //       Icons.arrow_forward_ios,
            //       color: Colors.white,
            //     ),
            //     onTap: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => Result(
            //                 isAdmin: true,
            //               )));
            //     },
            //   ),
            // ),
          ],
        ));
  }
}
