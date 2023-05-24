import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/helper/firebaseaut.dart';

class FirestoreHelper {
  Helper _helper = Helper();
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('user');

  Future<void> updateprofile(
      {required String email,
      required String gmeet,
      required String slot,
      required String specialisation,
      required String password,
      required String name,
      required String videocons,
      // required String imgurl,
      required String adhar}) async {
    try {
      final _user = await _helper.getUserCredentials();
      print("userid : ${_user!.uid}");
      bool isAproved = false;
      bool isadmin = false;
      await _collectionReference
          .doc(_user.uid)
          .set({
            'name': name,
            'fee': "200",
            'email': email,
            'slot': slot,
            'specialisation': specialisation,
            'doc_id': adhar,
            'isAproved': isAproved,
            'isAdmin': isadmin,
            'imgurl': "",
            'meet_link': gmeet,
            'consult_type': videocons,
            'password': password
            // 'img_url': imgurl
          }, SetOptions(merge: true))
          .then((value) => print("Document added successfully"))
          .catchError((error) => print("Failed to add document: $error"));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> addElection({
    required String name,
    required DateTime start_date,
    required DateTime end_date,
  }) async {
    try {
      final _ref = FirebaseFirestore.instance.collection('Elections');

      await _ref.add(
        {'name': name, 'start_date': start_date, "end_date": end_date},
      ).catchError((error) => print("Failed to add document: $error"));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> addCandidate({
    required String name,
    required String age,
    required String electionID,
    required String party,
  }) async {
    try {
      final _ref2 = FirebaseFirestore.instance
          .collection('Elections')
          .doc(electionID)
          .collection("candidates");

      await _ref2.add(
        {'name': name, 'age': age, 'party': party, 'votes': []},
      ).catchError((error) => print("Failed to add document: $error"));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> submitVote({
    required String name,
    required String age,
    required String electionID,
    required String party,
  }) async {
    try {
      final _ref2 = FirebaseFirestore.instance
          .collection('Elections')
          .doc(electionID)
          .collection("candidates");

      await _ref2.add(
        {'name': name, 'age': age, 'party': party, 'votes': 0},
      ).catchError((error) => print("Failed to add document: $error"));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
