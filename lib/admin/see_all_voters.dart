import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notes_app/models/user.dart';

class VotersList extends StatefulWidget {
  final bool isAdmin;
  const VotersList({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<VotersList> createState() => _VotersListState();
}

class _VotersListState extends State<VotersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doctor List '),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .orderBy('isAproved', descending: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // List<FirebaseUser> users = snapshot.data!.docs
              //     .map((document) =>
              //         FirebaseUser.fromMap(document.data()))
              // .toList();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => User(
                  specialisation: snapshot.data!.docs[index]['specialisation'],
                  // selfie_url: snapshot.data!.docs[index]['selfie_url'] ?? "",
                  onpressedreject: () {
                    String id = snapshot.data!.docs[index].id;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(id)
                        .delete();
                  },
                  isAdmin: snapshot.data!.docs[index]['isAproved'],
                  name: snapshot.data!.docs[index]['name'],
                  adhar: snapshot.data!.docs[index]['doc_id'],
                  email: snapshot.data!.docs[index]['email'],
                  img_url: snapshot.data!.docs[index]['imgurl'] ?? "",
                  onpressed: () {
                    String id = snapshot.data!.docs[index].id;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(id)
                        .update({'isAproved': true});
                  },
                ),
              );
            }));
  }
}

class User extends StatelessWidget {
  final bool isAdmin;
  final String name;
  final String adhar;
  final String email;
  final String specialisation;
  final String img_url;
  final String selfie_url;
  final void Function()? onpressed;
  final void Function()? onpressedreject;

  const User(
      {super.key,
      this.selfie_url = "",
      required this.isAdmin,
      required this.img_url,
      required this.name,
      required this.specialisation,
      required this.adhar,
      required this.email,
      required this.onpressed,
      required this.onpressedreject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          'Name: ${name}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Email : ${email}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Doc ID : ${adhar}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'specialisation: ${specialisation}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (!isAdmin) ...[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 30,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final imageProvider =
                                      Image.network(img_url).image;
                                  showImageViewer(context, imageProvider,
                                      onViewerDismissed: () {
                                    print("dismissed");
                                  });
                                },
                                child: Text("Doctor Certificate"))),
                      ),
                      // SizedBox(
                      //     height: 30,
                      //     child: ElevatedButton(
                      //         onPressed: () async {
                      //           final imageProvider =
                      //               Image.network(selfie_url).image;
                      //           showImageViewer(context, imageProvider,
                      //               onViewerDismissed: () {
                      //             print("dismissed");
                      //           });
                      //         },
                      //         child: Text("Image"))),
                    ],
                  ),
                ),
              ],
              Row(
                mainAxisAlignment:
                    isAdmin ? MainAxisAlignment.start : MainAxisAlignment.start,
                children: [
                  if (!isAdmin) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              onPressed: onpressed, child: Text("Aprove"))),
                    ),
                    SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            onPressed: onpressedreject, child: Text("reject"))),
                  ]
                ],
              ), // Text('Phone : ${}'),
            ],
          ),
        ),
        // trailing: Visibility(
        //   visible: !isAdmin,
        //   child: Container(
        //     height: double.infinity,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         // SizedBox(
        //         //   height: 10,
        //         //   child: IconButton(
        //         //     onPressed: () {},
        //         //     icon: const Icon(
        //         //       Icons.delete,
        //         //       color: Colors.red,
        //         //     ),
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
