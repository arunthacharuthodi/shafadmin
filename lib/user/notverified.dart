import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app/helper/const.dart';
import 'package:notes_app/login.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Account Yet to be Verified",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            // imageuploading?Row(children: [CircularProgressIndicator(), Text("image being uploaded only do back after ")],)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false);
                      },
                      child: Text("Back to sign In"))),
            )
          ],
        ),
      )),
    );
  }
}
