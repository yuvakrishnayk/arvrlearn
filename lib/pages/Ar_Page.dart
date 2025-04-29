import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ArPage extends StatelessWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Model Viewer')),
      body: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/models/.Spider.fbx', // Replace with your model path
        alt: '3D Model',
        ar: true,
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }
}