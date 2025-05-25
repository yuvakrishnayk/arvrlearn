import 'package:arvrlearn/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Professional color scheme
    final Color primaryColor = const Color(0xFF3949AB);
    final Color accentColor = const Color(0xFF5C6BC0);
    final Color backgroundColor = const Color(0xFFF5F7FA);
    final Color cardColor = Colors.white;
    final Color textDarkColor = const Color(0xFF2C3E50);
    final Color textLightColor = const Color(0xFF7F8C8D);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              // Open settings
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Custom profile header with gradient
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, accentColor],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
          ),

          // Profile avatar that overlaps the header
          Transform.translate(
            offset: const Offset(0, -60),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: cardColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/65.jpg',
                ),
              ),
            ),
          ),

          // Rest of the content (adjusted for overlap)
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Emily Johnson',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                            _buildProfileStatItem(
                              Icons.star,
                              'Achievements',
                              '5',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Learning Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
            ),
          ),
        ],
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
