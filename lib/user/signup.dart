import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/admin/home.dart';
import 'package:notes_app/admin/login.dart';
import 'package:notes_app/auth.dart';
import 'package:notes_app/helper/firebaseaut.dart';
import 'package:notes_app/home_screen.dart';
import 'package:notes_app/login.dart';
import 'package:notes_app/user/camera.dart';
import 'package:notes_app/user/notverified.dart';
import 'package:notes_app/user/user_home_page.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String dropdownValue = 'General';
  String dropdownValue2 = 'Online';
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _passWordConfirmController = TextEditingController();

  final _nameController = TextEditingController();
  final _gmeetController = TextEditingController();

  final _AsdharController = TextEditingController();
  bool is_buttonlogin = false;
  String selectedOption = 'morning';

  final _globalKey1 = GlobalKey<FormState>();
  String filePath = "";
  String filePathselfie = "";

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result == null) return;
    setState(() {
      filePath = result.files.single.path!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF151619),
        body: ListView(
          children: [
            const SizedBox(
              height: 150,
            ),
            const Center(
                child: Text(
              'Doctor Registration',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            )),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Form(
                      key: _globalKey1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              is_Name: false,
                              is_Adhar: false,
                              textFieldController: _emailController,
                              hintText: 'Email',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              is_Adhar: false,
                              is_Name: false,
                              isPassword: true,
                              textFieldController: _passwordController,
                              hintText: 'Password',
                              isVisible: true,
                              suffixIcon: const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 22,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              is_Name: false,
                              is_Adhar: false,
                              isPassword: true,
                              textFieldController: _passWordConfirmController,
                              hintText: 'Confirm Password',
                              isVisible: true,
                              suffixIcon: const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 22,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              is_Name: true,
                              is_Adhar: false,
                              textFieldController: _nameController,
                              hintText: 'Enter your name',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "your Doctor ID Number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              is_Adhar: false,
                              is_Name: false,

                              isPassword: false,
                              textFieldController: _AsdharController,
                              hintText: 'Doctor ID Number',
                              isVisible: false,
                              // suffixIcon: const Icon(
                              //   Icons.visibility_off,
                              //   color: Colors.grey,
                              //   size: 22,
                              // ),
                            ),
                          ])),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "google meet link",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    is_Adhar: false,
                    is_Name: false,
                    isPassword: false,
                    textFieldController: _gmeetController,
                    hintText: 'gmeet link',
                    isVisible: true,
                    suffixIcon: const Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Select Specialization",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButton<String>(
                        // focusColor: Colors.red,
                        // iconEnabledColor: true,
                        underline: Container(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue,
                        // borderRadius: BorderRadius.circular(8),
                        icon: Icon(Icons.arrow_drop_down_rounded),
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,

                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },

                        items: <String>[
                          'General',
                          'Skin',
                          'ENT',
                          'Cough and Fever',
                          'Gynaecology',
                          'Dentist'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Consultation Type",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButton<String>(
                        // focusColor: Colors.red,
                        // iconEnabledColor: true,
                        underline: Container(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue2,
                        // borderRadius: BorderRadius.circular(8),
                        icon: Icon(Icons.arrow_drop_down_rounded),
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,

                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue2 = value!;
                          });
                        },

                        items: <String>['Online', 'offline']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Slot Type",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RadioGroup(selectedOption: selectedOption!),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Proof of Certificate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: pickFile,
                            child: Text('Select File'),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      if (filePath != null)
                        Text(
                          'Selected file: ${filePath.split('/').last}',
                          style: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 50,
                      width: 300,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF2CC66D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0)),
                          side: const BorderSide(color: Color(0xFF2CC66D)),
                        ),
                        onPressed: () {
                          signup(context);
                        },
                        child: is_buttonlogin
                            ? CircularProgressIndicator()
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      )),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Visibility(
                        visible: true,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminLogin()));
                            },
                            child: const Text(
                              'Admin? Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2CC66D),
                                fontSize: 15,
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Have account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2CC66D),
                              fontSize: 15,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  signup(
    BuildContext context,
  ) {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is required'),
        ),
      );
      return;
    } else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is required'),
        ),
      );
      return;
    } else if (_passWordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirm Password is required'),
        ),
      );
      return;
    } else if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name is required'),
        ),
      );
      return;
    } else if (_AsdharController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('doctor id Number is required'),
        ),
      );
      return;
    }
    // else if (_AsdharController.text.length != 12) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('doctor certificate should be 12 numbers'),
    //     ),
    //   );
    // }
    else if (_passwordController.text != _passWordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and Confirm Password must be same'),
        ),
      );
      return;
    } else if (!RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$')
        .hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must Contain Least 6 characters and Letters and Digits'),
        ),
      );
    } else if (filePath == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select your doctor certificate Image'),
        ),
      );
    } else {
      try {
        setState(() {
          is_buttonlogin = true;
        });
        final _helperauth = Helper();
        _helperauth
            .firebasecreateuser(
                // file_name: filePath,
                gmeet: _gmeetController.text,
                slot: selectedOption!,
                context: context,
                file_path: filePath,
                specialisation: dropdownValue,
                videocons: dropdownValue2,
                // selfie_path: imageFile!.path,
                email: _emailController.text,
                password: _passwordController.text,
                adhar: _AsdharController.text,
                name: _nameController.text)
            .then((value) {
          setState(() {
            is_buttonlogin = false;
            imageFile = null;
          });
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
  }
}

//
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.is_Adhar,
    required this.is_Name,
    required this.textFieldController,
    this.isVisible = false,
    this.suffixIcon = const Icon(Icons.ac_unit),
    this.hintText = '',
    this.lineNo = 1,
    this.isPassword = false,
    this.inputType = TextInputType.streetAddress,
    this.inputColor = Colors.white,
  });

  final TextEditingController textFieldController;
  final bool isVisible;
  final Icon suffixIcon;
  final String hintText;
  final int lineNo;
  final bool isPassword;
  final TextInputType inputType;
  final Color inputColor;
  bool is_Adhar;
  final bool is_Name;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      color: Color(0xFF1E1F23),
      child: TextFormField(
        inputFormatters: widget.is_Name
            ? [
                FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+')),
              ]
            : null,
        maxLength: widget.is_Adhar ? 12 : null,
        keyboardType: widget.inputType,
        obscureText: obsecure && widget.isPassword,
        maxLines: widget.lineNo,
        style: TextStyle(color: widget.inputColor),
        controller: widget.textFieldController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(
            left: 20,
            top: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF2CC66D), width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: widget.hintText,
          suffixIcon: Visibility(
            visible: widget.isPassword,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    obsecure = !obsecure;
                  });
                },
                icon: obsecure
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility)),
          ),
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color(0xFF2CC66D),
          ),
        ),
      ),
    );
  }
}

class RadioGroup extends StatefulWidget {
  String selectedOption = 'morning';

  RadioGroup({required this.selectedOption});
  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          tileColor: Colors.white,
          title: Text('Morning'),
          value: 'morning',
          groupValue: widget.selectedOption,
          onChanged: (String? value) {
            setState(() {
              widget.selectedOption = value!;
            });
          },
        ),
        RadioListTile(
          tileColor: Colors.white,
          title: Text('Evening'),
          value: 'evening',
          groupValue: widget.selectedOption,
          onChanged: (String? value) {
            setState(() {
              widget.selectedOption = value!;
            });
          },
        ),
        RadioListTile(
          tileColor: Colors.white,
          title: Text('Full'),
          value: 'full',
          groupValue: widget.selectedOption,
          onChanged: (String? value) {
            setState(() {
              widget.selectedOption = value!;
            });
          },
        ),
      ],
    );
  }
}
