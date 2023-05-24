import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/helper/firebaseaut.dart';

class CloudStorageHelper {
  Future<void> UploadFile({
    required String file_path,
    // required String file_name,
  }) async {
    final collectionRef = FirebaseFirestore.instance.collection('user');
    final documentRef =
        collectionRef.doc(FirebaseAuth.instance.currentUser!.uid);

    final file = File(file_path);

    final storageRef = FirebaseStorage.instance.ref();
// final file = File('/path/to/file');
// final fileName = 'myFile.jpg';

    final uploadTask =
        storageRef.child(FirebaseAuth.instance.currentUser!.uid).putFile(file);

    uploadTask.snapshotEvents.listen((event) async {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      if (progress == 100.0) {
        try {
          final downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
          print('File uploaded successfully: $downloadUrl');
          documentRef.update(
            {'imgurl': downloadUrl},
          ).then((value) => "updated successfully");
          // await FirebaseAuth.instance.signOut();
        } catch (e) {
          print(e);
        }
      }
      print('Upload progress: $progress%');
    }, onError: (e) {
      print('Error uploading file: $e');
    }, onDone: () async {});
  }

  Future<void> UploadSelfie({
    required String file_path,
    // required String file_name,
  }) async {
    final collectionRef = FirebaseFirestore.instance.collection('user');
    final documentRef =
        collectionRef.doc(FirebaseAuth.instance.currentUser!.uid);

    final file = File(file_path);

    final storageRef = FirebaseStorage.instance.ref();
// final file = File('/path/to/file');
// final fileName = 'myFile.jpg';

    final uploadTask = storageRef
        .child(FirebaseAuth.instance.currentUser!.uid + "selfie_img")
        .putFile(file);

    uploadTask.snapshotEvents.listen((event) async {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      if (progress == 100.0) {
        try {
          final downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
          print('File uploaded successfully: $downloadUrl');
          documentRef.set({'selfie_url': downloadUrl},
              SetOptions(merge: true)).then((value) => "updated successfully");
          // await FirebaseAuth.instance.signOut();
        } catch (e) {
          print(e);
        }
      }
      print('Upload progress: $progress%');
    }, onError: (e) {
      print('Error uploading file: $e');
    }, onDone: () async {});
  }
}
