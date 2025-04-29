import 'package:flutter/material.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  String _selectedSubject = 'All';
  String _searchQuery = '';

  // Track completed assignments
  final Map<String, bool> _completedAssignments = {
    'Magnets: Attract and Repel': true,
    'Sorting Materials by Properties': true,
  };

  // Track submission dates for newly completed assignments
  final Map<String, String> _submissionDates = {};

  // List of all subjects for filtering
  final List<String> _subjects = [
    'All',
    'Physics',
    'Chemistry',
    'Social Science',
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4A26DB);
    final accentColor = Color(0xFF00E5BB);
    final backgroundColor = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Grade 1 Science",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search assignments...',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Subject Filter
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_subjects[index]),
                      selected: _selectedSubject == _subjects[index],
                      selectedColor: primaryColor.withOpacity(0.2),
                      onSelected: (selected) {
                        setState(() {
                          _selectedSubject = _subjects[index];
                        });
                      },
                      labelStyle: TextStyle(
                        color:
                            _selectedSubject == _subjects[index]
                                ? primaryColor
                                : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Assignments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showSortDialog(context);
                  },
                  icon: Icon(Icons.sort, size: 16, color: primaryColor),
                  label: Text('Sort', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_shouldShowAssignment('Physics', 'Push and Pull Forces') &&
                !_isAssignmentCompleted('Push and Pull Forces'))
              _buildAssignmentCard(
                'Push and Pull Forces',
                'Due: Tomorrow, 3:00 PM',
                'Physics',
                Colors.blue,
                primaryColor,
                accentColor,
                Icons.rocket_launch,
              ),

            if (_shouldShowAssignment('Chemistry', 'States of Matter') &&
                !_isAssignmentCompleted('States of Matter: Solid, Liquid, Gas'))
              _buildAssignmentCard(
                'States of Matter: Solid, Liquid, Gas',
                'Due: May 15, 3:00 PM',
                'Chemistry',
                Colors.green,
                primaryColor,
                accentColor,
                Icons.science,
              ),

            if (_shouldShowAssignment('Social Science', 'Community Helpers') &&
                !_isAssignmentCompleted(
                  'Community Helpers in Our Neighborhood',
                ))
              _buildAssignmentCard(
                'Community Helpers in Our Neighborhood',
                'Due: May 20, 3:00 PM',
                'Social Science',
                Colors.orange,
                primaryColor,
                accentColor,
                Icons.people,
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed Assignments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_getCompletedCount()} / ${_getTotalCount()}',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_shouldShowAssignment('Physics', 'Magnets') &&
                _isAssignmentCompleted('Magnets: Attract and Repel'))
              _buildCompletedAssignmentCard(
                'Magnets: Attract and Repel',
                _submissionDates['Magnets: Attract and Repel'] ??
                    'Submitted: May 1',
                'Grade: Star Learner ⭐',
                primaryColor,
                accentColor,
                'Physics',
                Icons.auto_fix_high,
              ),

            if (_shouldShowAssignment('Chemistry', 'Sorting Materials') &&
                _isAssignmentCompleted('Sorting Materials by Properties'))
              _buildCompletedAssignmentCard(
                'Sorting Materials by Properties',
                _submissionDates['Sorting Materials by Properties'] ??
                    'Submitted: April 25',
                'Grade: Great Job 👍',
                primaryColor,
                accentColor,
                'Chemistry',
                Icons.category,
              ),

            // Dynamically show newly completed assignments
            ..._getNewlyCompletedAssignments(),
          ],
        ),
      ),
    );
  }

  // Helper method to get newly completed assignments
  List<Widget> _getNewlyCompletedAssignments() {
    final primaryColor = Color(0xFF4A26DB);
    final accentColor = Color(0xFF00E5BB);
    List<Widget> widgets = [];

    // Push and Pull Forces
    if (_isAssignmentCompleted('Push and Pull Forces') &&
        _shouldShowAssignment('Physics', 'Push and Pull Forces')) {
      widgets.add(
        _buildCompletedAssignmentCard(
          'Push and Pull Forces',
          _submissionDates['Push and Pull Forces'] ?? 'Just now',
          'Grade: Pending',
          primaryColor,
          accentColor,
          'Physics',
          Icons.rocket_launch,
        ),
      );
    }

    // States of Matter
    if (_isAssignmentCompleted('States of Matter: Solid, Liquid, Gas') &&
        _shouldShowAssignment('Chemistry', 'States of Matter')) {
      widgets.add(
        _buildCompletedAssignmentCard(
          'States of Matter: Solid, Liquid, Gas',
          _submissionDates['States of Matter: Solid, Liquid, Gas'] ??
              'Just now',
          'Grade: Pending',
          primaryColor,
          accentColor,
          'Chemistry',
          Icons.science,
        ),
      );
    }

    // Community Helpers
    if (_isAssignmentCompleted('Community Helpers in Our Neighborhood') &&
        _shouldShowAssignment('Social Science', 'Community Helpers')) {
      widgets.add(
        _buildCompletedAssignmentCard(
          'Community Helpers in Our Neighborhood',
          _submissionDates['Community Helpers in Our Neighborhood'] ??
              'Just now',
          'Grade: Pending',
          primaryColor,
          accentColor,
          'Social Science',
          Icons.people,
        ),
      );
    }

    return widgets;
  }

  // Get count of completed assignments
  int _getCompletedCount() {
    return _completedAssignments.values.where((v) => v).length;
  }

  // Get total count of assignments
  int _getTotalCount() {
    return 5; // Fixed number based on our assignments
  }

  // Check if assignment is completed
  bool _isAssignmentCompleted(String title) {
    return _completedAssignments[title] ?? false;
  }

  // Mark assignment as completed
  void _markAsCompleted(String title) {
    setState(() {
      _completedAssignments[title] = true;

      // Add today's date as submission date
      final now = DateTime.now();
      _submissionDates[title] = 'Submitted: ${now.month}/${now.day}';
    });

    // Show completion feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text('Great job! Assignment completed.')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            _showAssignmentDetail(title, 'Completed');
          },
        ),
      ),
    );
  }

  // Show assignment details
  void _showAssignmentDetail(String title, String status) {
    String description;
    String instruction;
    List<String> materials = [];
    IconData icon;
    Color color;

    // Set details based on assignment title
    if (title.contains('Push and Pull')) {
      description = 'Learn about forces that make objects move.';
      instruction = 'Find 5 examples of push and pull forces in your home.';
      materials = ['Paper', 'Pencil', 'Toys'];
      icon = Icons.rocket_launch;
      color = Colors.blue;
    } else if (title.contains('States of Matter')) {
      description = 'Explore solids, liquids and gases around us.';
      instruction = 'Draw and label examples of each state of matter.';
      materials = ['Coloring book', 'Crayons', 'Glass of water'];
      icon = Icons.science;
      color = Colors.green;
    } else if (title.contains('Community Helpers')) {
      description = 'Learn about people who help in our community.';
      instruction = 'Draw your favorite community helper and what they do.';
      materials = ['Coloring book', 'Crayons'];
      icon = Icons.people;
      color = Colors.orange;
    } else if (title.contains('Magnets')) {
      description = "Discover how magnets attract and repel.";
      instruction = "Test different objects to see if they're magnetic.";
      materials = ['Magnet', 'Various household objects'];
      icon = Icons.auto_fix_high;
      color = Colors.indigo;
    } else {
      description = 'Explore different materials and their properties.';
      instruction = 'Sort objects by texture, size, and color.';
      materials = ['Various small objects', 'Sorting tray'];
      icon = Icons.category;
      color = Colors.teal;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          status == 'Completed'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color:
                            status == 'Completed'
                                ? Colors.green
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(icon, color: color),
                  ),
                  SizedBox(width: 12),
                  Text(
                    status == 'Completed'
                        ? _submissionDates[title] ?? 'Submitted recently'
                        : 'Due soon',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(
                'Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(instruction, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(
                'Materials Needed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...materials.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(item, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              Spacer(),
              if (status != 'Completed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _markAsCompleted(title);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Mark as Complete',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Show dialog to help with assignments
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help with Assignments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                Icons.search,
                'Search for assignments using the search bar',
              ),
              _buildHelpItem(
                Icons.filter_list,
                'Filter by subject with the chips',
              ),
              _buildHelpItem(
                Icons.visibility,
                'View details of any assignment',
              ),
              _buildHelpItem(
                Icons.assignment_turned_in,
                'Complete your assignments to earn stars',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it!'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  // Helper widget for help dialog
  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4A26DB), size: 20),
          SizedBox(width: 12),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }

  // Show dialog to sort assignments
  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Sort By'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sorted by due date'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Due Date (Earliest first)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sorted by subject'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Subject (A-Z)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sorted by title'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Title (A-Z)'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  // Show dialog to create a new assignment
  void _showNewAssignmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Assignment'),
          content: Text('This feature will be available soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  bool _shouldShowAssignment(String subject, String title) {
    // Filter by selected subject
    if (_selectedSubject != 'All' && subject != _selectedSubject) {
      return false;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty &&
        !title.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return false;
    }

    return true;
  }

  Widget _buildAssignmentCard(
    String title,
    String dueDate,
    String subject,
    Color subjectColor,
    Color primaryColor,
    Color accentColor,
    IconData subjectIcon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: subjectColor.withOpacity(0.2),
                  child: Icon(subjectIcon, color: subjectColor),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: subjectColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subject,
                          style: TextStyle(
                            color: subjectColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(dueDate, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _showAssignmentDetail(title, 'Pending');
                  },
                  icon: Icon(Icons.visibility, size: 18),
                  label: Text('View'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _markAsCompleted(title);
                  },
                  icon: Icon(Icons.assignment_turned_in, size: 18),
                  label: Text('Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedAssignmentCard(
    String title,
    String submittedDate,
    String grade,
    Color primaryColor,
    Color accentColor,
    String subject,
    IconData subjectIcon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(subjectIcon, color: primaryColor),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subject,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(submittedDate, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grade,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _showAssignmentDetail(title, 'Completed');
                  },
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
