import 'package:arvrlearn/models/question_model.dart';
import 'package:arvrlearn/pages/quiz_taking_page.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final primaryColor = const Color(0xFF4A26DB);
  final accentColor = const Color(0xFF00E5BB);
  final backgroundColor = const Color(0xFFF8F9FE);

  // Add search controller
  final TextEditingController _searchController = TextEditingController();
  // Add filtered quizzes list
  List<Map<String, dynamic>> filteredQuizzes = [];

  List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Chemistry',

      'questions': 10,
      // Adding time field that was missing
      'icon': Icons.science,
    },
    {
      'title': 'Maths',

      'questions': 10,
      // Adding time field that was missing
      'icon': Icons.calculate,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize filtered quizzes with all quizzes
    filteredQuizzes = List.from(quizzes);

    // Add listener to search controller
    _searchController.addListener(_filterQuizzes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to filter quizzes based on search text
  void _filterQuizzes() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredQuizzes = List.from(quizzes);
      } else {
        filteredQuizzes =
            quizzes
                .where(
                  (quiz) => quiz['title'].toString().toLowerCase().contains(
                    searchTerm,
                  ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Let's Quiz",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search quizzes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Quizzes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredQuizzes.length, // Use filtered quizzes
              itemBuilder: (context, index) {
                final quiz = filteredQuizzes[index]; // Use filtered quizzes
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Get the appropriate questions based on subject
                      List<Question> questions = [];
                      if (quiz['title'] == 'Chemistry') {
                        questions = SubjectQuestions.getChemistryQuestions();
                      } else if (quiz['title'] == 'Maths') {
                        questions = SubjectQuestions.getMathQuestions();
                      }

                      // Navigate to quiz taking page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => QuizTakingPage(
                                subject: quiz['title'] as String,
                                questions: questions,
                                timeInMinutes: 15, // Fixed parameter
                              ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ), // Fixed missing closing parenthesis
                            child: Icon(
                              quiz['icon'] as IconData,
                              color: primaryColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quiz['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      '${quiz['questions']} Questions',
                                      Icons.help_outline,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        chipColor = Colors.green;
        break;
      case 'intermediate':
        chipColor = Colors.orange;
        break;
      case 'advanced':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
