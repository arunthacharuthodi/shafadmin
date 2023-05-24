import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes_app/admin/addcandidate.dart';
import 'package:notes_app/blockchain_services.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/helper/firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShowElections extends StatefulWidget {
  const ShowElections({super.key});

  @override
  State<ShowElections> createState() => _AddCandidateState();
}

class _AddCandidateState extends State<ShowElections> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime selecteddate = DateTime(2023);

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var notesServices = context.watch<BlockchainServices>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('select election'),
      ),
      body: Container(
        height: 500,
        child: StreamBuilder<QuerySnapshot>(
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
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['name'],
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          "Start Date : ${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['start_date'].toDate())}",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "End Date :${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['end_date'].toDate())}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddCandidate(
                              electioId: snapshot.data!.docs[index].id),
                        ));
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
