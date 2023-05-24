import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/admin/home.dart';
import 'package:notes_app/helper/cloud_storeage.dart';
import 'package:notes_app/helper/firestore.dart';
import 'package:notes_app/user/notverified.dart';
import 'package:notes_app/user/user_home_page.dart';

class Helper {
  // FirestoreHelper _helperfirestore = FirestoreHelper();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<User?> getUserCredentials() async {
    final current_user = await _firebaseAuth.currentUser;
    return current_user;
  }

  Future<bool> isUsersigned() async {
    return await _firebaseAuth.currentUser == null ? false : true;
  }

  Future<void> firebasecreateuser({
    required String email,
    required String gmeet,
    required String slot,
    required BuildContext context,
    required String password,
    required String name,
    required String videocons,
    required String specialisation,
    required String adhar,
    required String file_path,
    // required String selfie_path,
    // required String file_name,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirestoreHelper().updateprofile(
          slot: slot,
          gmeet: gmeet,
          videocons: videocons,
          //       required String file_path,
          // required String file_name,
          // imgurl: imgurl,
          specialisation: specialisation,
          adhar: adhar,
          email: email,
          name: name,
          password: password);
      Future.wait([
        CloudStorageHelper().UploadFile(file_path: file_path),
        // CloudStorageHelper().UploadSelfie(file_path: selfie_path)
      ]);

      _firebaseAuth.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NotVerified()));
    } catch (e) {
      print(e);
    }
  }

  Future<void> firebaselogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .where('isAproved', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print("No user found / not verified yet");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found / not verified yet")));
      } else {
        print("user found");
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => UserHomaPage(),
            ),
            (route) => false);
      }
    } on FirebaseException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
    // print(collectionReference.doc("6ghBClLvmqaoyfpXIQzPvYSi4c52"));

    // await _firebaseAuth.signInWithEmailAndPassword(
    //     email: email, password: password);
  }

  Future<void> firebaseSignout() => _firebaseAuth.signOut();

  Future<void> firebaseAdminlogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .where('isAdmin', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print("No user found / Or User Is Not a Admin");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found / Or User Is Not a Admin")));
      } else {
        print("user found");
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      }
    } on FirebaseException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
    // print(collectionReference.doc("6ghBClLvmqaoyfpXIQzPvYSi4c52"));

    // await _firebaseAuth.signInWithEmailAndPassword(
    //     email: email, password: password);
  }

  Future<String> sendVerification(
      {required BuildContext context, required String phonenumber}) async {
    String smscode = "";
    try {
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        verificationCompleted: (phoneAuthCredential) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "send a verification codode to ${phoneAuthCredential.verificationId}")));
          print(phoneAuthCredential.smsCode);
          smscode = phoneAuthCredential.smsCode!;
        },
        verificationFailed: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("send a verification failed")));
        },
        codeSent: (verificationId, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      return smscode;
    } catch (e) {
      throw Exception("faliled to verify phone number");
    }
  }
}
