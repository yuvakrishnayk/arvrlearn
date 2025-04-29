import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/65.jpg',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alex Johnson',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'AR/VR Enthusiast',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileStatItem(
                      Icons.school,
                      'Courses Completed',
                      '12',
                    ),
                    const Divider(),
                    _buildProfileStatItem(
                      Icons.timer,
                      'Total Learning Time',
                      '15h 42m',
                    ),
                    const Divider(),
                    _buildProfileStatItem(Icons.star, 'Achievements', '5'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Learning Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('AI Personalization Level'),
                      subtitle: Text('High - Uses all available data'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Daily Reminders'),
                      subtitle: Text('Enabled - 7:30 PM'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.videocam),
                      title: Text('Preferred Content Type'),
                      subtitle: Text('Video tutorials with exercises'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Log out
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
