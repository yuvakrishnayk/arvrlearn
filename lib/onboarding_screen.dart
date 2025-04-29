import 'package:arvrlearn/homepage.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to Smart AR Tutor',
      'description':
          'The next generation of learning with augmented reality and artificial intelligence',
      'image': 'assets/images/onboarding1.png',
      'icon': Icons.school,
    },
    {
      'title': 'Interactive 3D Learning',
      'description':
          'Explore complex concepts with interactive 3D models in augmented reality',
      'image': 'assets/images/onboarding2.png',
      'icon': Icons.view_in_ar,
    },
    {
      'title': 'AI-Powered Personalization',
      'description':
          'Adaptive learning experience that adjusts to your needs and learning style',
      'image': 'assets/images/onboarding3.png',
      'icon': Icons.psychology,
    },
    {
      'title': 'Learn Anywhere, Anytime',
      'description':
          'Take your learning to the next level with AR experiences in your environment',
      'image': 'assets/images/onboarding4.png',
      'icon': Icons.location_on,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => _navigateToHome(),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    title: _onboardingData[index]['title'],
                    description: _onboardingData[index]['description'],
                    image: _onboardingData[index]['image'],
                    icon: _onboardingData[index]['icon'],
                  );
                },
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String image,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for image - replace with actual images
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(
                0xFFE6E6FA,
              ).withOpacity(0.5), // Light lavender color
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 100,
              color: const Color(0xFF5D3FD3),
            ), // Royal purple
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333), // Dark text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ), // Medium gray for subtitle
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => _buildDotIndicator(index),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: const Color(0xFF5D3FD3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _currentPage == _onboardingData.length - 1
                  ? 'Get Started'
                  : 'Next',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              if (_currentPage == _onboardingData.length - 1) {
                _navigateToHome();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
          ),
          if (_currentPage != _onboardingData.length - 1) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Skip to Login',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              onPressed: () => _navigateToHome(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            _currentPage == index
                ? const Color(0xFF5D3FD3)
                : const Color(0xFFE6E6FA),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
