import 'package:flutter/material.dart';

class ARVRPage extends StatelessWidget {
  final String name;
  final String path;

  const ARVRPage({Key? key, required this.name, required this.path})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Color(0xFF4A89DC)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar, size: 100, color: Color(0xFF4A89DC)),
            SizedBox(height: 20),
            Text(
              'AR/VR View for $name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Using model: $path',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text('Start Experience'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A89DC),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                // This would launch your AR/VR experience
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Launching AR/VR experience for $name'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
