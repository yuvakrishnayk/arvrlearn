import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LearnEdge'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Learner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Today is ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildDailyGoalCard(),
            const SizedBox(height: 24),
            const Text(
              'Recommended for You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecommendedLessons(),
            const SizedBox(height: 24),
            const Text(
              'Your Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProgressChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.flag, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Learning Goal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('70% completed - 14/20 minutes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedLessons() {
    final lessons = [
      {'title': 'AR Basics', 'progress': 0.3, 'category': 'Beginner'},
      {'title': 'VR Interactions', 'progress': 0.8, 'category': 'Intermediate'},
      {'title': 'AI in ARVR', 'progress': 0.1, 'category': 'Advanced'},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson['category'] as String,
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    LinearProgressIndicator(
                      value: lesson['progress'] as double,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((lesson['progress'] as double) * 100).toInt()}% completed',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressChart() {
    // This would be replaced with an actual chart in a real app
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
                Text('Sun'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 60,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 30,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 80,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 50,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 70,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 90,
                  width: 20,
                  child: ColoredBox(color: Colors.deepPurple),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Your learning activity this week'),
          ],
        ),
      ),
    );
  }
}
