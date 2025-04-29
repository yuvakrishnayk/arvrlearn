import 'package:flutter/material.dart';



class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  int _selectedCategory = 0;
  final List<String> categories = [
    'All',
    'AR',
    'VR',
    'Mixed Reality',
    'AI Integration',
  ];
  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Augmented Reality Fundamentals',
      'instructor': 'Dr. Sarah Wilson',
      'rating': 4.8,
      'students': 1234,
      'image':
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?ixlib=rb-1.2.1&auto=format&fit=crop',
      'price': '\$49.99',
      'category': 'AR',
      'bestseller': true,
    },
    {
      'title': 'Virtual Reality Development',
      'instructor': 'Prof. James Miller',
      'rating': 4.6,
      'students': 986,
      'image':
          'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?ixlib=rb-1.2.1&auto=format&fit=crop',
      'price': '\$59.99',
      'category': 'VR',
      'bestseller': false,
    },
    {
      'title': 'Mixed Reality Experiences',
      'instructor': 'Emma Rodriguez',
      'rating': 4.9,
      'students': 1567,
      'image':
          'https://images.unsplash.com/photo-1626379953822-baec19c3accd?ixlib=rb-1.2.1&auto=format&fit=crop',
      'price': '\$79.99',
      'category': 'Mixed Reality',
      'bestseller': true,
    },
    {
      'title': 'AI in Extended Reality',
      'instructor': 'Dr. Michael Chen',
      'rating': 4.7,
      'students': 752,
      'image':
          'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?ixlib=rb-1.2.1&auto=format&fit=crop',
      'price': '\$69.99',
      'category': 'AI Integration',
      'bestseller': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCourses =
        _selectedCategory == 0
            ? courses
            : courses
                .where(
                  (course) =>
                      course['category'] == categories[_selectedCategory],
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AR/VR Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: _selectedCategory == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? index : 0;
                      });
                    },
                    selectedColor: Colors.deepPurple.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color:
                          _selectedCategory == index
                              ? Colors.deepPurple
                              : Colors.black,
                      fontWeight:
                          _selectedCategory == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              course['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (course['bestseller'])
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[700],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'BESTSELLER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Instructor: ${course['instructor']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Text(
                                  ' ${course['rating']} (${course['students']} students)',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                Text(
                                  course['price'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Enroll Now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
