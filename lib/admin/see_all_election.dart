// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAllElections extends StatelessWidget {
  // const SeeAllElections({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Elections').snapshots(),
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
                itemBuilder: (context, index) => ResultItem(
                  docID: snapshot.data!.docs[index].id,
                  // isAdmin: snapshot.data!.docs[index]['isAdmin'],
                  name: snapshot.data!.docs[index]['name'],
                  // adhar: snapshot.data!.docs[index]['adhar'],
                  // email: snapshot.data!.docs[index]['email'],
                ),
              );
            }));
  }
}

class ResultItem extends StatelessWidget {
  // final bool isAdmin;
  final String name;
  final String docID;
  ResultItem({
    // required this.isAdmin,
    required this.name,
    required this.docID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(name),
        subtitle: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Elections')
                .doc(docID)
                .collection('candidates')
                // .orderBy('votes.length')
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
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(snapshot.data?.docs[index]['name']),
                    Text("Party: ${snapshot.data?.docs[index]['party']}"),
                    Text("Age: ${snapshot.data?.docs[index]['age']}")
                  ],
                ),
              );
            }),
        // trailing: Visibility(
        //   // visible: isAdmin,
        //   child: Column(
        //     children: [
        //       Expanded(
        //           child: IconButton(
        //         onPressed: () {},
        //         icon: const Icon(
        //           Icons.check_box,
        //           color: Colors.white,
        //         ),
        //       )),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
