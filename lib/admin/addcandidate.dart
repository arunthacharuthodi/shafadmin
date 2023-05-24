import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes_app/blockchain_services.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/helper/firestore.dart';
import 'package:provider/provider.dart';

class AddCandidate extends StatefulWidget {
  final String electioId;

  const AddCandidate({super.key, required this.electioId});

  @override
  State<AddCandidate> createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController _agecontroller = TextEditingController();
  final TextEditingController _partyController = TextEditingController();
  DateTime selecteddate = DateTime(2023);
  bool deleteLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // init();
  }

  Future<void> init() async {
    QuerySnapshot snashot = await FirebaseFirestore.instance
        .collection('Elections')
        .doc(widget.electioId)
        .collection('candidates')
        .get();
    if (snashot.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('Elections')
          .doc(widget.electioId)
          .collection("candidates")
          .add({});
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _partyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var notesServices = context.watch<BlockchainServices>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add candidate'),
      ),
      body: Container(
        height: 500,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Elections')
                .doc(widget.electioId)
                .collection('candidates')
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
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['name'],
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Remove Candidate"),
                                content: Text(
                                    "Are you sure you want to remove ${snapshot.data!.docs[index]['name']}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        deleteLoading = true;
                                      });
                                      // Remove the candidate from the database
                                      FirebaseFirestore.instance
                                          .collection('Elections')
                                          .doc(widget.electioId)
                                          .collection('candidates')
                                          .doc(snapshot.data!.docs[index].id)
                                          .delete()
                                          .then((value) {
                                        setState(() {
                                          deleteLoading = false;
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: deleteLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator())
                                        : Text("Remove"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        )),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Age: ${snapshot.data!.docs[index]['age']}"),
                        Text("${snapshot.data!.docs[index]['party']}"),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Candidate'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name Of candidate',
                      ),
                    ),
                    TextField(
                      controller: _agecontroller,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                      ),
                    ),
                    TextField(
                      controller: _partyController,
                      decoration: const InputDecoration(
                        hintText: 'Party',
                      ),
                    ),

                    // TextField(
                    //   // controller: descriptionController,
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter address',
                    //   ),
                    // ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final _helper = FirestoreHelper();
                      await _helper.addCandidate(
                          electionID: widget.electioId,
                          party: _partyController.text,
                          name: titleController.text,
                          age: _agecontroller.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
