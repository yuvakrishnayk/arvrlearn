import 'package:flutter/material.dart';
import 'package:arvrlearn/models/question_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizTakingPage extends StatefulWidget {
  final String subject;
  final List<Question> questions;
  final int timeInMinutes;

  const QuizTakingPage({
    Key? key,
    required this.subject,
    required this.questions,
    required this.timeInMinutes,
  }) : super(key: key);

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  bool _showingAnalysis = false;
  bool _isAnalyzing = false;
  late List<int?> _userAnswers;
  String _analysis = "";
  List<String> _improvementPoints = [];
  String _encouragement = "";
  final String _geminiApiKey =
      "AIzaSyCZ7XcW8116NZQCZpMpEBLLk9hGkBtt2Cg"; // Replace with your actual API key

  // Sample analysis data for different subjects
  final Map<String, Map<String, dynamic>> _sampleAnalysisData = {
    "Mathematics": {
      "analysis":
          "Based on your performance in the Mathematics quiz, you've shown good understanding of basic concepts but need more practice with advanced problems.",
      "improvementPoints": [
        "Practice more algebraic equations",
        "Work on geometry proofs",
        "Improve speed in calculations",
        "Focus on word problems",
        "Review trigonometric identities",
      ],
      "encouragement":
          "Math is all about practice! Keep working on problems daily and you'll see improvement.",
    },
    "Science": {
      "analysis":
          "Your Science quiz results show you have a solid foundation but need to work on applying concepts to real-world scenarios.",
      "improvementPoints": [
        "Understand scientific method better",
        "Memorize key formulas",
        "Practice experimental design",
        "Learn scientific terminology",
        "Connect concepts across topics",
      ],
      "encouragement":
          "Science is everywhere! Try relating what you learn to everyday life for better understanding.",
    },
    "History": {
      "analysis":
          "Your History quiz performance indicates you remember key events but need to work on dates and historical connections.",
      "improvementPoints": [
        "Create timelines for better visualization",
        "Focus on cause-effect relationships",
        "Memorize important dates",
        "Understand historical contexts",
        "Connect events across regions",
      ],
      "encouragement":
          "History tells our story! The more you learn about the past, the better you'll understand the present.",
    },
    "English": {
      "analysis":
          "Your English quiz results show strong vocabulary but need improvement in grammar rules and literary analysis.",
      "improvementPoints": [
        "Practice verb tenses",
        "Work on sentence structure",
        "Read more diverse literature",
        "Learn literary devices",
        "Improve proofreading skills",
      ],
      "encouragement":
          "Language is power! Keep reading and writing to become an even better communicator.",
    },
    "General Knowledge": {
      "analysis":
          "Your General Knowledge quiz shows you're well-rounded but could benefit from focusing on current affairs and specialized topics.",
      "improvementPoints": [
        "Follow daily news",
        "Learn about different cultures",
        "Study basic economics",
        "Explore scientific discoveries",
        "Read about world geography",
      ],
      "encouragement":
          "Knowledge is endless! Stay curious and keep learning new things every day.",
    },
  };

  @override
  void initState() {
    super.initState();
    _userAnswers = List<int?>.filled(widget.questions.length, null);
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });
    _analyzeQuizResultsWithGemini();
  }

  Future<void> _analyzeQuizResultsWithGemini() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Prepare the prompt for Gemini
      String prompt = """
Analyze the following quiz results and provide detailed feedback:

**Subject**: ${widget.subject}
**Total Questions**: ${widget.questions.length}
**Correct Answers**: $_score
**Percentage Score**: ${(_score / widget.questions.length * 100).toStringAsFixed(1)}%

**Questions and Answers**:
${_generateQuestionAnswerText()}

Please provide:
1. A detailed analysis of the performance
2. 5 specific improvement points based on the incorrect answers
3. An encouraging message tailored to the score
""";

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$_geminiApiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final analysisText =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        // Parse the Gemini response (this is a simple parser, you might need to adjust based on actual response format)
        final sections = analysisText.split('\n\n');

        setState(() {
          _analysis = sections.isNotEmpty ? sections[0] : "";
          _improvementPoints =
              sections.length > 1
                  ? sections[1]
                      .split('\n')
                      .where((line) => line.trim().isNotEmpty)
                      .toList()
                  : [];
          _encouragement = sections.length > 2 ? sections[2] : "";
          _showingAnalysis = true;
          _isAnalyzing = false;
        });
      } else {
        throw Exception('Failed to get analysis from Gemini API');
      }
    } catch (e) {
      // Fallback to local analysis if API fails
      _fallbackAnalysis();
      print('Error calling Gemini API: $e');
    }
  }

  String _generateQuestionAnswerText() {
    String result = "";
    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      final userAnswerIndex = _userAnswers[i];
      final isCorrect = userAnswerIndex == question.correctAnswerIndex;

      result += """
Question ${i + 1}: ${question.question}
Your Answer: ${userAnswerIndex != null ? question.options[userAnswerIndex] : "Not answered"}
Correct Answer: ${question.options[question.correctAnswerIndex]}
Status: ${isCorrect ? "Correct" : "Incorrect"}
""";
    }
    return result;
  }

  void _fallbackAnalysis() {
    final percentage = (_score / widget.questions.length) * 100;

    // Get the default subject or use "General Knowledge" if not found
    final subjectData =
        _sampleAnalysisData[widget.subject] ??
        _sampleAnalysisData["General Knowledge"]!;

    // Customize the analysis based on percentage
    String performanceLevel;
    if (percentage >= 80) {
      performanceLevel = 'excellent';
    } else if (percentage >= 60) {
      performanceLevel = 'good';
    } else {
      performanceLevel = 'fair';
    }

    setState(() {
      _analysis =
          "You scored ${percentage.toStringAsFixed(0)}% on the ${widget.subject} quiz. "
          "This is a $performanceLevel performance. ${subjectData['analysis']}";

      _improvementPoints = List<String>.from(subjectData['improvementPoints']);

      _encouragement =
          percentage >= 80
              ? "Outstanding work! ${subjectData['encouragement']}"
              : percentage >= 60
              ? "Well done! ${subjectData['encouragement']}"
              : "Keep practicing! ${subjectData['encouragement']}";

      _showingAnalysis = true;
      _isAnalyzing = false;
    });
  }

  void _selectAnswer(int selectedIndex) {
    if (_userAnswers[_currentQuestionIndex] == null) {
      setState(() {
        _userAnswers[_currentQuestionIndex] = selectedIndex;
        if (selectedIndex ==
            widget.questions[_currentQuestionIndex].correctAnswerIndex) {
          _score++;
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (_currentQuestionIndex < widget.questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
          });
        } else {
          _completeQuiz();
        }
      });
    }
  }

  Color _getOptionColor(int optionIndex) {
    if (_userAnswers[_currentQuestionIndex] == null) {
      return Colors.white;
    }

    final correctIndex =
        widget.questions[_currentQuestionIndex].correctAnswerIndex;

    if (optionIndex == correctIndex) {
      return Colors.green.shade100;
    } else if (optionIndex == _userAnswers[_currentQuestionIndex]) {
      return Colors.red.shade100;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      if (_showingAnalysis) {
        return _buildAnalysisScreen();
      }
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subject} Quiz',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
      backgroundColor: const Color(0xFFF5F5F8),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.deepPurple.shade100, width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        Icons.question_mark,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.deepPurple.shade800,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $_score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://img.freepik.com/free-vector/hand-drawn-school-doodles_23-2148093823.jpg',
                  ),
                  opacity: 0.08,
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.questions[_currentQuestionIndex].question,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      widget.questions[_currentQuestionIndex].options.length,
                      (index) => AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(index),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getOptionColor(index),
                              border: Border.all(
                                color: Colors.deepPurple.withOpacity(0.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.deepPurple
                                      .withOpacity(0.1),
                                  radius: 16,
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    widget
                                        .questions[_currentQuestionIndex]
                                        .options[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _currentQuestionIndex > 0
                          ? () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade100,
                    foregroundColor: Colors.deepPurple.shade800,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(
                    'Previous',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _currentQuestionIndex < widget.questions.length - 1
                          ? () {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          }
                          : () => _completeQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: Text(
                    _currentQuestionIndex < widget.questions.length - 1
                        ? 'Next'
                        : 'Finish',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    _currentQuestionIndex < widget.questions.length - 1
                        ? Icons.arrow_forward
                        : Icons.check_circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Analysis',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            setState(() {
              _showingAnalysis = false;
            });
          },
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F8),
      body:
          _isAnalyzing
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.deepPurple,
                      strokeWidth: 6,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Generating Detailed Analysis...',
                      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  radius: 24,
                                  child: Icon(
                                    Icons.analytics,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Performance Analysis',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      Text(
                                        '${widget.subject} Quiz',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    '$_score/${widget.questions.length}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 30),
                            Text(
                              _analysis,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Areas for Improvement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._improvementPoints.asMap().entries.map((entry) {
                      final index = entry.key;
                      final point = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade800,
                              ),
                            ),
                          ),
                          title: Text(
                            point,
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 3,
                      color: Colors.amber.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 24,
                              child: Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Keep Going!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _encouragement,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(
                          Icons.assignment_return,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Return to Quizzes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / widget.questions.length) * 100;
    String message = '';
    IconData resultIcon;

    if (percentage >= 80) {
      message = 'Amazing! You\'re a star!';
      resultIcon = Icons.emoji_events;
    } else if (percentage >= 60) {
      message = 'Good job! Keep practicing!';
      resultIcon = Icons.sentiment_very_satisfied;
    } else {
      message = 'Keep trying! You\'ll get better!';
      resultIcon = Icons.sentiment_satisfied;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(resultIcon, color: Colors.amber, size: 100),
            ),
            const SizedBox(height: 30),
            Text(
              message,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$_score',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        '/${widget.questions.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          percentage >= 70
                              ? Colors.green.shade100
                              : percentage >= 40
                              ? Colors.orange.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            percentage >= 70
                                ? Colors.green.shade700
                                : percentage >= 40
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(
                    'Back to Quizzes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex = 0;
                      _score = 0;
                      _quizCompleted = false;
                      _showingAnalysis = false;
                      _userAnswers = List<int?>.filled(
                        widget.questions.length,
                        null,
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.replay),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showingAnalysis = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text(
                'View Detailed Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
