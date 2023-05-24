import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingHistory extends StatefulWidget {
  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  String doc_id = "";
  bool isLoading = false;
  @override
  void initState() {
    getDoctorId();
    // TODO: implement initState
    super.initState();
  }

  void _launchURL(String _meetLink) async {
    if (await canLaunchUrl(Uri.parse(_meetLink))) {
      final uri = Uri.parse(_meetLink);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_meetLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking History"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('appoinments')
                  .where(
                    'doctor',
                    isEqualTo: doc_id,
                  )
                  .where('status', isEqualTo: 'booked')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text('No Data'),
                    );
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => Card(
                              child: ListTile(
                                title: Container(
                                  child: Text('Doctor: ${e['doc_name']}'),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mode: ${e['type']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Status: ${e['status']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Slot: ${DateFormat("dd MMM yyyy hh:mm a").format(e['start_time'].toDate())}\t-\t${DateFormat("hh:mm a").format(e['end_time'].toDate())}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (!(e['type'] == 'offline')) ...[
                                      ElevatedButton(
                                        onPressed: () async {
                                          final Uri emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: e['name'],
                                            query: encodeQueryParameters(<
                                                String, String>{
                                              'subject':
                                                  'Example Subject & Symbols are allowed!',
                                            }),
                                          );

                                          launchUrl(emailLaunchUri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        child: Text("send prescription"),
                                      ),
                                    ]
                                  ],
                                ),
                                trailing: e['type'] == 'offline'
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () async {
                                          _launchURL(e['meet_link']);
                                          // if (await canLaunchUrl(
                                          //     Uri.parse(e['meet_link']))) {
                                          //   launchUrl(
                                          //       Uri.parse(e['meet_link']));
                                          // } else {
                                          //   if (kDebugMode) {
                                          //     print("unable to launch");
                                          //   }
                                          // }
                                        },
                                        child: Text("Meet"),
                                      ),
                              ),
                            ))
                        .toList(),
                  );
                }
                return Center(
                  child: Text("Something went wrong"),
                );
              }),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> getDoctorId() async {
    isLoading = true;
    setState(() {});

    final user = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      doc_id = user.id;
      print(doc_id);
    });
    isLoading = false;
    setState(() {});
  }
}
