import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/user/vote_now.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String CandidateId;

  OtpVerificationPage({required this.phoneNumber, required this.CandidateId});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _verificationId;
  String? smscode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Verification'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Your password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      print(widget.phoneNumber);
                      if (widget.phoneNumber == _codeController.text) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VotingBooth(CandidateId: widget.CandidateId),
                            ),
                            (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Wrong password'),
                          ),
                        );
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Verify password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    final PhoneVerificationCompleted verified =
        (PhoneAuthCredential authResult) {
      print(authResult.token);
      setState(() {
        smscode = authResult.smsCode;
      });
      // You can handle verification completed scenarios here.
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number verification failed'),
        ),
      );
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceCodeResent]) {
      _verificationId = verId;
      setState(() {
        _isLoading = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      _verificationId = verId;
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout,
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
