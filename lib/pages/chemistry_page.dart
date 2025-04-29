import 'package:flutter/material.dart';
import 'package:arvrlearn/Models/course_model.dart';
import 'package:arvrlearn/ar_vr.dart';

class ChemistryPage extends StatefulWidget {
  const ChemistryPage({super.key});

  @override
  State<ChemistryPage> createState() => _ChemistryPageState();
}

class _ChemistryPageState extends State<ChemistryPage> {
  // Sample course data for Chemistry
  final List<Course> courses = [
    Course(
      topic: 'Matter & Materials',
      subtopics: [
        'Solids & Liquids',
        'Gases',
        'Properties of Matter',
        'Changes in Matter',
      ],
    ),
    Course(
      topic: 'Basic Elements',
      subtopics: [
        'What are Elements?',
        'Common Elements',
        'Element Groups',
        'Elements Around Us',
      ],
    ),
    Course(
      topic: 'Simple Mixtures',
      subtopics: [
        'Mixing Things',
        'Separating Mixtures',
        'Solutions',
        'Water as a Solvent',
      ],
    ),
    Course(
      topic: 'Introduction to Reactions',
      subtopics: [
        'Chemical Changes',
        'Physical Changes',
        'Color Changes',
        'Heat & Reactions',
      ],
    ),
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Chemistry Basics',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/chem.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.deepPurple, Colors.deepPurple],
                          ),
                        ),
                        child: Icon(
                          Icons.science,
                          size: 80,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course Overview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Discover the fascinating world of chemistry through hands-on experiments and interactive lessons.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoCard(Icons.book, '4 Topics'),
                      SizedBox(width: 16),
                      _buildInfoCard(Icons.timer, '10 Hours'),
                      SizedBox(width: 16),
                      _buildInfoCard(Icons.star, '4.7/5'),
                    ],
                  ),
                  Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),
                  Text(
                    'Course Content',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Course Content List
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final course = courses[index];
              final isExpanded = index == _expandedIndex;

              return Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Topic Header
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? -1 : index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getIconForTopic(course.topic),
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.topic,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${course.subtopics.length} subtopics',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Subtopics (Expandable)
                    AnimatedCrossFade(
                      firstChild: Container(height: 0),
                      secondChild: Column(
                        children: [
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: course.subtopics.length,
                            separatorBuilder:
                                (context, index) => Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 56,
                                  color: Colors.grey.shade200,
                                ),
                            itemBuilder: (context, subtopicIndex) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.deepPurple
                                      .withOpacity(
                                    0.1,
                                  ),
                                  child: Text(
                                    '${subtopicIndex + 1}',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  course.subtopics[subtopicIndex],
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.deepPurple,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ARVRPage(
                                            name:
                                                course.subtopics[subtopicIndex],
                                            path: 'assets/chemistry.glb',
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      crossFadeState:
                          isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                ),
              );
            }, childCount: courses.length),
          ),

          // Extra space at the bottom
          SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open the first topic by default
          setState(() {
            _expandedIndex = 0;
          });
        },
        label: Text('Start Learning'),
        icon: Icon(Icons.play_arrow),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple),
            SizedBox(height: 8),
            Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTopic(String topic) {
    switch (topic.toLowerCase()) {
      case 'matter & materials':
        return Icons.category;
      case 'basic elements':
        return Icons.view_module;
      case 'simple mixtures':
        return Icons.bubble_chart;
      case 'introduction to reactions':
        return Icons.local_fire_department;
      default:
        return Icons.science;
    }
  }
}
