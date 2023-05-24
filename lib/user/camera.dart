import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

File? imageFile;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller = CameraController(
      CameraDescription(
          name: "",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0),
      ResolutionPreset.high);
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.isGranted) {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras.last,
        ResolutionPreset.medium,
      );
      await _controller.initialize();
      setState(() {});
    } else {
      Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _takePicture,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Future<void> _takePicture() async {
    try {
      XFile picture = await _controller.takePicture();
      setState(() {
        imageFile = File(picture.path);
        print(imageFile);
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? picture = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (picture != null) {
        setState(() {
          imageFile = File(picture.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
