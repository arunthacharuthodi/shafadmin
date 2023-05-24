import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:notes_app/blockchain_services.dart';
import 'package:notes_app/config/color.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/helper/firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddElection extends StatefulWidget {
  const AddElection({super.key});

  @override
  State<AddElection> createState() => _AddElectionState();
}

class _AddElectionState extends State<AddElection> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController _startdateController = TextEditingController();
  final TextEditingController _enddateController = TextEditingController();
  DateTime selected_start_date = DateTime(2023);
  DateTime selected_end_date = DateTime(2023);
  bool deleteLoading = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _enddateController.dispose();
    _startdateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var notesServices = context.watch<BlockchainServices>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Election'),
      ),
      body: Container(
        height: double.infinity,
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        tileColor: ColorCOnfig().secondary,
                        title: Text(
                          snapshot.data!.docs[index]['name'],
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                                "Start Date : ${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['start_date'].toDate())}"),
                            Text(
                                "End Date :${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['end_date'].toDate())}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Remove Election ?"),
                                  content: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            "Are you sure you want to remove ",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text:
                                            "${snapshot.data!.docs[index]['name']}?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ])),
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
                                              child:
                                                  CircularProgressIndicator())
                                          : Text("Remove"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
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
                title: const Text('New Election'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name Of election',
                      ),
                    ),
                    TextFormField(
                      controller: _startdateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            // Show a date picker dialog
                            DateTime? Selecteddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            // Update the text field with the selected date
                            if (Selecteddate != null) {
                              _startdateController.text =
                                  Selecteddate.toString();
                              setState(() {
                                selected_start_date = Selecteddate;
                              });
                            }
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _enddateController,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            // Show a date picker dialog
                            DateTime? Selecteddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            // Update the text field with the selected date
                            if (Selecteddate != null) {
                              _enddateController.text = Selecteddate.toString();
                              setState(() {
                                selected_end_date = Selecteddate;
                              });
                            }
                          },
                          child: Icon(Icons.calendar_today),
                        ),
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
                      await _helper.addElection(
                          name: titleController.text,
                          start_date: selected_start_date,
                          end_date: selected_end_date);
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
