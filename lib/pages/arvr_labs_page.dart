import 'package:flutter/material.dart';
import 'package:arvrlearn/pages/assignments_page.dart';

class ARVRLabsPage extends StatefulWidget {
  const ARVRLabsPage({super.key});

  @override
  State<ARVRLabsPage> createState() => _ARVRLabsPageState();
}

class _ARVRLabsPageState extends State<ARVRLabsPage> {
  final Set<String> _completedLabs = {};
  final Set<String> _activeLabs = {};
  String? _currentLab;
  String _searchQuery = '';
  String _currentFilter = 'All';

  // Grade 1 appropriate labs data
  final List<Map<String, dynamic>> _grade1Labs = [
    {
      'title': 'Animal Friends',
      'description': 'Meet and learn about different animals',
      'category': 'Life Science',
      'icon': Icons.pets,
      'color': Colors.amber,
      'isNew': true,
      'content': {
        'sections': [
          {
            'title': 'Farm Animals',
            'image':
                'https://th.bing.com/th/id/OIP.XNFWs1LsYEpCG0XGQD-L9AHaF0?w=205&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'facts': [
              'Cows say "moo" and give us milk',
              'Pigs like to roll in mud to stay cool',
              'Chickens lay eggs we can eat',
            ],
            'activity': 'Drag the animal to its favorite food!',
          },
          {
            'title': 'Jungle Animals',
            'image':
                'https://th.bing.com/th/id/OIP.XNFWs1LsYEpCG0XGQD-L9AHaF0?w=205&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'facts': [
              'Lions are called the "king of the jungle"',
              'Monkeys love to eat bananas',
              'Elephants use their trunks to drink water',
            ],
            'activity': 'Match the animal to its home!',
          },
        ],
      },
    },
    {
      'title': 'Plant Grow',
      'description': 'Watch how plants grow from tiny seeds',
      'category': 'Life Science',
      'icon': Icons.eco,
      'color': Colors.green,
      'isNew': false,
      'content': {
        'sections': [
          {
            'title': 'Seed to Plant',
            'image':
                'https://cdn.leverageedu.com/blog/wp-content/uploads/2020/08/05195501/Class-11-plant-growth-and-development.png',
            'facts': [
              'Plants need water, sun, and soil to grow',
              'Roots grow down into the soil',
              'Leaves use sunlight to make food',
            ],
            'activity': 'Put the growth stages in order!',
          },
        ],
      },
    },
    {
      'title': 'Magnet Magic',
      'description': 'Discover what sticks to magnets',
      'category': 'Physics',
      'icon': Icons.science,
      'color': Colors.blue,
      'isNew': true,
      'content': {
        'sections': [
          {
            'title': 'Magnetic or Not?',
            'image':
                'https://th.bing.com/th/id/OIP.eBnbRvkZRwGRRLxhFKd33gHaGK?rs=1&pid=ImgDetMain',
            'facts': [
              'Magnets stick to some metals',
              'Magnets have a north and south pole',
              'Opposite poles attract each other',
            ],
            'activity': 'Test which items are magnetic!',
          },
        ],
      },
    },
    {
      'title': 'Shadow Play',
      'description': 'Explore how light makes shadows',
      'category': 'Physics',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
      'isNew': false,
      'content': {
        'sections': [
          {
            'title': 'Light and Dark',
            'image':
                'https://th.bing.com/th/id/OIP.XNFWs1LsYEpCG0XGQD-L9AHaF0?w=205&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'facts': [
              'Light can\'t go through solid objects',
              'Bigger lights make softer shadows',
              'The sun makes our shadow outside',
            ],
            'activity': 'Make different shadow shapes!',
          },
        ],
      },
    },
    {
      'title': 'Sink or Float',
      'description': 'Test which objects sink in water',
      'category': 'Chemistry',
      'icon': Icons.water,
      'color': Colors.indigo,
      'isNew': false,
      'content': {
        'sections': [
          {
            'title': 'Water Fun',
            'image':
                'https://th.bing.com/th/id/OIP.XNFWs1LsYEpCG0XGQD-L9AHaF0?w=205&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'facts': [
              'Heavy things often sink',
              'Air helps things float',
              'Boats float even though they\'re big',
            ],
            'activity': 'Predict which items will float!',
          },
        ],
      },
    },
    {
      'title': 'Community Helpers',
      'description': 'Meet people who help our town',
      'category': 'Social Science',
      'icon': Icons.people,
      'color': Colors.purple,
      'isNew': true,
      'content': {
        'sections': [
          {
            'title': 'Helpers Around Us',
            'image':
                'https://th.bing.com/th/id/OIP.XNFWs1LsYEpCG0XGQD-L9AHaF0?w=205&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'facts': [
              'Firefighters keep us safe from fires',
              'Doctors help when we\'re sick',
              'Teachers help us learn new things',
            ],
            'activity': 'Match helpers to their tools!',
          },
        ],
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4A26DB);
    final accentColor = Color(0xFF00E5BB);
    final backgroundColor = Color(0xFFF8F9FE);

    // Filter labs based on search and category filter
    final filteredLabs =
        _grade1Labs.where((lab) {
          final matchesSearch =
              lab['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              _searchQuery.isEmpty;
          final matchesFilter =
              _currentFilter == 'All' || lab['category'] == _currentFilter;
          return matchesSearch && matchesFilter;
        }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Grade 1 Science Fun",
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
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and filter bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find a science lab...',
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
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text(_currentFilter),
                  selected: _currentFilter != 'All',
                  onSelected: (_) => _showFilterDialog(context),
                  backgroundColor: Colors.white,
                  selectedColor: accentColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: _currentFilter != 'All' ? primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Current lab section
            if (_currentLab != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Your Current Lab',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCurrentLabCard(),
                  const SizedBox(height: 16),
                ],
              ),

            // Labs section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Science Labs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAllFiltersDialog(context),
                  icon: Icon(Icons.filter_list, size: 16, color: primaryColor),
                  label: Text('Filter', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display filtered labs
            ...filteredLabs
                .map(
                  (lab) => _buildLabCard(
                    lab['title'],
                    lab['description'],
                    lab['category'],
                    lab['icon'],
                    lab['color'],
                    primaryColor,
                    accentColor,
                    lab['isNew'],
                  ),
                )
                .toList(),

            const SizedBox(height: 24),

            // Completed labs section
            if (_completedLabs.isNotEmpty) ...[
              const Text(
                'Completed Labs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ..._grade1Labs
                  .where((lab) => _completedLabs.contains(lab['title']))
                  .map(
                    (lab) => _buildCompletedLabCard(
                      lab['title'],
                      lab['category'],
                      lab['icon'],
                      lab['color'],
                      primaryColor,
                      accentColor,
                    ),
                  ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssignmentsPage()),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.assignment),
        tooltip: 'View Assignments',
      ),
    );
  }

  Widget _buildCurrentLabCard() {
    if (_currentLab == null) return SizedBox.shrink();

    final lab = _grade1Labs.firstWhere((l) => l['title'] == _currentLab);
    final primaryColor = Color(0xFF4A26DB);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.5), width: 2),
        ),
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
                      color: lab['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(lab['icon'], color: lab['color'], size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lab['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'In Progress',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: 0.6, // Could track actual progress
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showLabAssignments(lab['title']),
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
                    onPressed: () => _resumeLab(lab['title']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabCard(
    String title,
    String description,
    String category,
    IconData icon,
    Color iconColor,
    Color primaryColor,
    Color accentColor,
    bool isNew,
  ) {
    final bool isActive = _activeLabs.contains(title);
    final bool isCompleted = _completedLabs.contains(title);

    if (isCompleted) return SizedBox.shrink();

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
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    category,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (!isActive)
                      IconButton(
                        icon: Icon(Icons.info_outline, color: primaryColor),
                        onPressed:
                            () => _showLabDetails(
                              context,
                              title,
                              description,
                              category,
                              icon,
                              iconColor,
                            ),
                        tooltip: 'Lab Information',
                      ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed:
                          () => isActive ? _resumeLab(title) : _startLab(title),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? Colors.green : primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(
                        isActive ? Icons.play_arrow : Icons.science,
                        size: 16,
                      ),
                      label: Text(isActive ? 'Continue' : 'Start Lab'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedLabCard(
    String title,
    String category,
    IconData icon,
    Color iconColor,
    Color primaryColor,
    Color accentColor,
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
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
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showLabAssignments(title),
                  icon: Icon(Icons.assignment, size: 16),
                  label: Text('Assignments'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _restartLab(title),
                  icon: Icon(Icons.refresh, size: 16),
                  label: Text('Do Again'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
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

  // Lab management methods
  void _startLab(String title) {
    setState(() {
      _activeLabs.add(title);
      _currentLab = title;
    });
    _showLabStartDialog(title);
  }

  void _resumeLab(String title) {
    setState(() {
      _currentLab = title;
    });
    _showLabContentDialog(title);
  }

  void _restartLab(String title) {
    setState(() {
      _completedLabs.remove(title);
      _activeLabs.add(title);
      _currentLab = title;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restarting $title lab'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _showLabStartDialog(title);
  }

  void _completeLab(String title) {
    setState(() {
      _activeLabs.remove(title);
      _completedLabs.add(title);
      if (_currentLab == title) _currentLab = null;
    });
    _showLabCompletionDialog(title);
  }

  // Dialog and content methods
  void _showLabStartDialog(String title) {
    final lab = _grade1Labs.firstWhere((l) => l['title'] == title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Starting ${lab['title']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get ready for some science fun!'),
              SizedBox(height: 16),
              Text('What you\'ll need:'),
              SizedBox(height: 8),
              _buildLabMaterialsList(title),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showLabContentDialog(title);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A26DB),
              ),
              child: Text('Start Now'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  Widget _buildLabMaterialsList(String title) {
    List<String> materials = [];

    if (title == 'Animal Friends') {
      materials = ['Animal pictures', 'Coloring crayons'];
    } else if (title == 'Plant Grow') {
      materials = ['Seeds', 'Small cup', 'Soil', 'Water'];
    } else if (title == 'Magnet Magic') {
      materials = ['Magnet', 'Various small objects'];
    } else if (title == 'Shadow Play') {
      materials = ['Flashlight', 'Small toys'];
    } else if (title == 'Sink or Float') {
      materials = ['Bowl of water', 'Various small objects'];
    } else {
      materials = ['Helper pictures', 'Crayons'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          materials
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(item),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  void _showLabContentDialog(String title) {
    final lab = _grade1Labs.firstWhere((l) => l['title'] == title);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lab['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var section in lab['content']['sections']) ...[
                        Text(
                          section['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lab['color'],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Fun Facts:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var fact in section['facts'])
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(child: Text(fact)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Activity:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(section['activity']),
                        SizedBox(height: 24),
                        if (section != lab['content']['sections'].last)
                          Divider(),
                        if (section != lab['content']['sections'].last)
                          SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _completeLab(title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4A26DB),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Complete Lab', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLabCompletionDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.celebration, color: Colors.amber),
              SizedBox(width: 10),
              Text('Great Job!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You completed the $title lab!'),
              SizedBox(height: 20),
              Image.asset(
                'assets/celebration.png',
                width: 200,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                'Would you like to do the assignment now?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showLabAssignments(title);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A26DB),
              ),
              child: Text('Yes, Start Now'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _showLabAssignments(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssignmentsPage()),
    );
  }

  void _showLabDetails(
    BuildContext context,
    String title,
    String description,
    String category,
    IconData icon,
    Color iconColor,
  ) {
    final lab = _grade1Labs.firstWhere((l) => l['title'] == title);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: iconColor.withOpacity(0.2),
                    radius: 25,
                    child: Icon(icon, color: iconColor, size: 30),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          category,
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'About this Lab:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'What you\'ll learn:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var fact in lab['content']['sections'][0]['facts'].take(
                    3,
                  ))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Expanded(child: Text(fact)),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _startLab(title);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A26DB),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Start Lab', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Use Science Labs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(Icons.science, 'Pick a fun lab to explore'),
              _buildHelpItem(Icons.play_arrow, 'Tap "Start Lab" to begin'),
              _buildHelpItem(Icons.games, 'Do the activities and learn'),
              _buildHelpItem(Icons.celebration, 'Finish to get a star'),
              _buildHelpItem(Icons.assignment, 'Try the assignments too!'),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Filter Labs'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentFilter = 'All');
                Navigator.pop(context);
              },
              child: Text('All Labs'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentFilter = 'Life Science');
                Navigator.pop(context);
              },
              child: Text('Life Science'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentFilter = 'Physics');
                Navigator.pop(context);
              },
              child: Text('Physics'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentFilter = 'Chemistry');
                Navigator.pop(context);
              },
              child: Text('Chemistry'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentFilter = 'Social Science');
                Navigator.pop(context);
              },
              child: Text('Social Science'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _showAllFiltersDialog(BuildContext context) {
    final categories = [
      'All',
      'Life Science',
      'Physics',
      'Chemistry',
      'Social Science',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Labs'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  trailing:
                      _currentFilter == categories[index]
                          ? Icon(Icons.check, color: Color(0xFF4A26DB))
                          : null,
                  onTap: () {
                    setState(() => _currentFilter = categories[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }
}
