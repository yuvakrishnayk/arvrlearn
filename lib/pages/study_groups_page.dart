import 'package:flutter/material.dart';
import 'package:arvrlearn/pages/assignments_page.dart';

class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  String _searchQuery = '';
  // Track joined groups
  final Set<String> _joinedGroups = {
    'Animal Explorers',
    'Weather Watchers',
    'Magnet Magic',
  };
  // Track completed assignments
  final Map<String, bool> _completedAssignments = {
    'Find animal pictures': true,
    'Draw your favorite animal': false,
    'Daily weather chart': true,
    'Cloud shapes activity': false,
    'Sort magnetic items': false,
    'Magnet strength test': false,
  };

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4A26DB);
    final accentColor = Color(0xFF00E5BB);
    final backgroundColor = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Science Buddies",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Find a science group...',
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

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Science Groups',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showJoinNewGroupDialog(context);
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Join New'),
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

            const SizedBox(height: 16),

            _buildStudyGroupCard(
              'Animal Explorers',
              'Next activity: Today, 3:00 PM',
              '8 friends',
              Icons.pets,
              Colors.amber,
              primaryColor,
              accentColor,
              [
                _buildAssignmentTile(
                  'Find animal pictures',
                  _completedAssignments['Find animal pictures'] ?? false,
                ),
                _buildAssignmentTile(
                  'Draw your favorite animal',
                  _completedAssignments['Draw your favorite animal'] ?? false,
                ),
              ],
            ),

            _buildStudyGroupCard(
              'Weather Watchers',
              'Next activity: Tomorrow, 2:00 PM',
              '6 friends',
              Icons.wb_sunny,
              Colors.orange,
              primaryColor,
              accentColor,
              [
                _buildAssignmentTile(
                  'Daily weather chart',
                  _completedAssignments['Daily weather chart'] ?? false,
                ),
                _buildAssignmentTile(
                  'Cloud shapes activity',
                  _completedAssignments['Cloud shapes activity'] ?? false,
                ),
              ],
            ),

            _buildStudyGroupCard(
              'Magnet Magic',
              'Next activity: Thursday, 3:30 PM',
              '7 friends',
              Icons.science,
              Colors.blue,
              primaryColor,
              accentColor,
              [
                _buildAssignmentTile(
                  'Sort magnetic items',
                  _completedAssignments['Sort magnetic items'] ?? false,
                ),
                _buildAssignmentTile(
                  'Magnet strength test',
                  _completedAssignments['Magnet strength test'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fun Science Groups',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildRecommendedGroupCard(
              'Plant Growers Club',
              '10 friends',
              'Life Science',
              Icons.eco,
              Colors.green,
              primaryColor,
              accentColor,
            ),

            _buildRecommendedGroupCard(
              'Water Explorers',
              '8 friends',
              'Chemistry',
              Icons.water_drop,
              Colors.cyan,
              primaryColor,
              accentColor,
            ),

            _buildRecommendedGroupCard(
              'Light & Shadow Fun',
              '12 friends',
              'Physics',
              Icons.lightbulb,
              Colors.yellow[700]!,
              primaryColor,
              accentColor,
            ),

            const SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple[200]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coming Soon: Science Fair!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Get ready for fun experiments and projects! Join a group to start preparing.",
                    style: TextStyle(fontSize: 14, color: Colors.purple[700]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "June 15",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinNewGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Join a New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red[100],
                  child: Icon(Icons.biotech, color: Colors.red),
                ),
                title: Text('Science Experiments'),
                subtitle: Text('15 friends'),
                onTap: () {
                  _joinGroup('Science Experiments');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple[100],
                  child: Icon(Icons.coronavirus, color: Colors.purple),
                ),
                title: Text('Human Body Explorers'),
                subtitle: Text('9 friends'),
                onTap: () {
                  _joinGroup('Human Body Explorers');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _joinGroup(String groupName) {
    setState(() {
      _joinedGroups.add(groupName);
    });

    // Show a snackbar to confirm the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You joined the $groupName group!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Could navigate to group details
          },
        ),
      ),
    );
  }

  void _leaveGroup(String groupName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Leave Group'),
          content: Text('Are you sure you want to leave $groupName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _joinedGroups.remove(groupName);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You left the $groupName group'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Leave', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _toggleAssignmentCompletion(String assignment) {
    setState(() {
      if (_completedAssignments.containsKey(assignment)) {
        _completedAssignments[assignment] =
            !(_completedAssignments[assignment] ?? false);
      } else {
        _completedAssignments[assignment] = true;
      }
    });

    // Show completion feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _completedAssignments[assignment]!
              ? 'Great job completing: $assignment!'
              : 'Marked as incomplete: $assignment',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            _completedAssignments[assignment]! ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showStartActivityDialog(String groupName, String activityInfo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  activityInfo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Activity Materials:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildMaterialItem('Science Textbook', Icons.menu_book),
                _buildMaterialItem('Pencil and Paper', Icons.edit),
                _buildMaterialItem('Activity Worksheet', Icons.description),

                const SizedBox(height: 24),
                const Text(
                  'Participants:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildParticipantChip('Emma'),
                    _buildParticipantChip('Jacob'),
                    _buildParticipantChip('Ava'),
                    _buildParticipantChip('Sophia'),
                    _buildParticipantChip('Liam'),
                    _buildParticipantChip('You', isCurrentUser: true),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Show joining animation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Activity started! Have fun learning!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      'Start Activity Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterialItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildParticipantChip(String name, {bool isCurrentUser = false}) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: isCurrentUser ? Colors.deepPurple : Colors.grey[300],
        child: Text(
          name[0],
          style: TextStyle(
            color: isCurrentUser ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      label: Text(name),
      backgroundColor:
          isCurrentUser ? Colors.deepPurple.withOpacity(0.1) : null,
    );
  }

  Widget _buildAssignmentTile(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleAssignmentCompletion(title),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey[400]!,
                  width: 1,
                ),
              ),
              child:
                  isCompleted
                      ? Icon(Icons.check, size: 16, color: Colors.green)
                      : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleAssignmentCompletion(title),
              child: Text(
                title,
                style: TextStyle(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted ? Colors.grey[600] : Colors.black87,
                ),
              ),
            ),
          ),
          if (!isCompleted)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(Icons.star, size: 16, color: Colors.amber),
            ),
        ],
      ),
    );
  }

  Widget _buildStudyGroupCard(
    String title,
    String meetingInfo,
    String members,
    IconData icon,
    Color iconColor,
    Color primaryColor,
    Color accentColor,
    List<Widget> assignments,
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
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
                      const SizedBox(height: 4),
                      Text(members, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.group),
                                title: const Text('View Members'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Viewing group members'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.exit_to_app),
                                title: const Text('Leave Group'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _leaveGroup(title);
                                },
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              meetingInfo,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Assignments:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),

            ...assignments,

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to assignments view for this group
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.assignment, size: 16),
                  label: Text('Assignments'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showStartActivityDialog(title, meetingInfo);
                  },
                  icon: Icon(Icons.play_circle_filled, size: 16),
                  label: Text('Start Activity'),
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

  Widget _buildRecommendedGroupCard(
    String title,
    String members,
    String category,
    IconData icon,
    Color iconColor,
    Color primaryColor,
    Color accentColor,
  ) {
    final bool isJoined = _joinedGroups.contains(title);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(members, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 6),
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
                      category,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isJoined
                ? OutlinedButton.icon(
                  onPressed: () => _leaveGroup(title),
                  icon: Icon(Icons.check, size: 16, color: Colors.green),
                  label: Text('Joined', style: TextStyle(color: Colors.green)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
                : OutlinedButton.icon(
                  onPressed: () => _joinGroup(title),
                  icon: Icon(Icons.person_add, size: 16),
                  label: Text('Join'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
