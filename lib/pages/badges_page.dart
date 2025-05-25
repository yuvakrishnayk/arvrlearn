import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = const Color(0xFF00E5BB);

    final badges = [
      {
        'title': 'Diamond Badge',
        'description': 'Earned by completing 30 days streak',
        'animation': 'assets/diamond.json',
        'color': Colors.blue,
        'gradient': [Color(0xFF5E17EB), Color(0xFF2F8AF5)],
        'url': 'https://company1.com/redeem',
        'points': 500,
      },
      {
        'title': 'Gold Badge',
        'description': 'Earned by completing 20 days streak',
        'animation': 'assets/gold.json',
        'color': Colors.amber,
        'gradient': [Color(0xFFFFD700), Color(0xFFFFA500)],
        'url': 'https://company2.com/redeem',
        'points': 300,
      },
      {
        'title': 'Bronze Badge',
        'description': 'Earned by completing 10 days streak',
        'animation': 'assets/bronze.json',
        'color': Colors.brown,
        'gradient': [Color(0xFFCD7F32), Color(0xFF8B4513)],
        'url': 'https://company3.com/redeem',
        'points': 100,
      },
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          'Your Achievements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 1, // Changed from 2 to 1 card per row (full width)
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1, // Changed from 0.4 to 1.6 (wider than tall)
          children:
              badges.map((b) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: (b['gradient'] as List<Color>),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                              b['animation'] as String,
                              width: 90,
                              height: 90,
                              repeat: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            b['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b['description'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${b['points']} points',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _launchURL(b['url'] as String),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: b['color'] as Color,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Redeem',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
