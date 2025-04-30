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
            'facts': [
              'Cows have four stomachs to help them digest grass',
              'Sheep grow a new coat of wool every year',
              'Horses can sleep standing up on their legs',
              'Ducks have waterproof feathers that keep them dry',
            ],
            'activity':
                'AR Farm Adventure: Create your own virtual farm! Place 3D animals anywhere in your room and care for them. Feed cows hay, give horses carrots, and watch sheep grow wool. Complete farm challenges like collecting eggs from chickens or milking cows. Record animal sounds and match them to the right animals to earn farm badges!',
            'interactive': true,
            'difficulty': 'easy',
            'goals': [
              'Identify 5 different farm animals',
              'Learn what each animal eats',
              'Discover animal lifecycles',
              'Complete farm caretaker tasks',
            ],
            'skills': ['observation', 'matching', 'caretaking'],
          },
          {
            'title': 'Jungle Animals',
            'facts': [
              'Tigers have striped skin, not just striped fur',
              'Monkeys use their tails to hang from trees',
              'Giraffes have the same number of neck bones as humans: seven',
              'Elephants can recognize themselves in a mirror',
            ],
            'activity':
                'Jungle Rescue Mission: Your AR device transforms into a wildlife explorer tool! Animals are hiding in your room - find them using animal tracking clues and jungle sounds. Use hand gestures to build bridges, clear paths, and help reunite baby animals with their parents. Create a safe habitat for each animal with the right food, water, and shelter. Take photos for your digital wildlife journal and earn conservation badges!',
            'interactive': true,
            'difficulty': 'medium',
            'goals': [
              'Rescue 5 jungle animals',
              'Create appropriate habitats',
              'Learn about animal adaptations',
              'Complete wildlife researcher tasks',
            ],
            'skills': ['problem-solving', 'empathy', 'conservation awareness'],
          },
          {
            'title': 'Ocean Animals',
            'facts': [
              'Octopuses have three hearts and blue blood',
              'Dolphins sleep with one eye open',
              'Starfish can regrow their arms if they lose one',
              'Whales breathe air even though they live in water',
            ],
            'activity':
                'Underwater Discovery: Dive into a virtual ocean! Use hand gestures to swim deeper and discover marine creatures. Collect information about each animal you find to complete your digital ocean journal.',
            'interactive': true,
            'difficulty': 'medium',
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
            'facts': [
              'Seeds need water to start growing (germination)',
              'The first thing to grow from a seed is the root',
              'The stem grows up toward the sunlight',
              'Leaves make food for the plant using sunlight',
            ],
            'activity':
                'Virtual Garden: Plant digital seeds and control their growth using hand gestures. Add water, sunlight, and nutrients at the right time to help your plant grow. Can you grow a complete healthy plant?',
            'interactive': true,
            'difficulty': 'easy',
          },
          {
            'title': 'Plant Parts',
            'facts': [
              'Roots absorb water and nutrients from the soil',
              'The stem supports the plant and carries water to leaves',
              'Leaves make food using sunlight and air',
              'Flowers help plants make new seeds',
            ],
            'activity':
                'Plant Doctor: Diagnose what\'s wrong with different virtual plants. Is it getting too much water? Not enough sun? Fix the problems by adjusting conditions and watch the plants recover.',
            'interactive': true,
            'difficulty': 'medium',
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
            'facts': [
              'Magnets attract objects made of iron, nickel, or cobalt',
              'Magnets can work through some materials like paper and plastic',
              'Every magnet has a north pole and a south pole',
              'The Earth is like a giant magnet with north and south poles',
            ],
            'activity':
                'Magnet Detective: Use a virtual magnet to hunt for hidden metal objects in your AR environment. Score points by correctly predicting which items will be attracted to your magnet before testing them.',
            'interactive': true,
            'difficulty': 'easy',
          },
          {
            'title': 'Magnetic Fields',
            'facts': [
              'Magnets create an invisible force field around them',
              'Magnetic fields can push or pull other magnets',
              'Similar poles (N-N or S-S) push each other away',
              'Different poles (N-S) pull toward each other',
            ],
            'activity':
                'Magnet Maze: Use VR controls to guide a magnetic ball through a maze. You\'ll need to use other magnets to push and pull your ball around obstacles. Watch out for tricky turns!',
            'interactive': true,
            'difficulty': 'hard',
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
            'facts': [
              'Shadows form when an object blocks light',
              'Moving closer to a light source makes shadows bigger',
              'Moving away from a light source makes shadows smaller',
              'Transparent objects let most light pass through',
            ],
            'activity':
                'Create shadow puppets with your hands in front of a virtual light! Try making different animal shapes.',
          },
          {
            'title': 'Sun Shadows',
            'facts': [
              'The sun makes shadows that change during the day',
              'Shadows are shortest at noon when the sun is highest',
              'Shadows are longest in the morning and evening',
              'We can tell time using shadows (sundials)',
            ],
            'activity':
                'Watch a virtual day pass and see how shadows change length and direction with the sun\'s movement.',
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
            'facts': [
              'Objects float when they weigh less than the water they push aside',
              'This pushing-aside force is called buoyancy',
              'Objects with air inside often float better',
              'The shape of an object can help it float or sink',
            ],
            'activity':
                'Drop different objects into a virtual tank of water and predict if they\'ll sink or float. Then test your predictions!',
          },
          {
            'title': 'Boat Building',
            'facts': [
              'Boats float even when made of heavy materials like steel',
              'The shape of a boat helps it float by pushing aside water',
              'Adding too much weight can make a boat sink',
              'Different boat shapes work better in different water conditions',
            ],
            'activity':
                'Design and build your own boat using different materials. Test how much weight it can carry before sinking!',
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
            'facts': [
              'Firefighters wear special gear to protect them from heat and smoke',
              'Police officers help keep our communities safe',
              'Paramedics provide emergency medical care',
              'Mail carriers deliver letters and packages to homes and businesses',
            ],
            'activity':
                'Visit different places in town and meet the helpers! Tap on each person to learn about their job.',
          },
          {
            'title': 'Emergency Helpers',
            'facts': [
              'Dial 911 in an emergency to get help quickly',
              'Firefighters use special trucks with ladders and hoses',
              'Ambulances have medical equipment to help sick or injured people',
              'Lifeguards watch swimmers to keep them safe in the water',
            ],
            'activity':
                'Help solve different emergency scenarios! Match the right helper to each situation and learn what to do.',
          },
          {
            'title': 'School Helpers',
            'facts': [
              'Teachers help us learn new things every day',
              'Principals lead the school and make important decisions',
              'School nurses help when students don\'t feel well',
              'Custodians keep the school clean and in good repair',
            ],
            'activity':
                'Explore a virtual school and find all the helpers! Learn what each person does to make school a great place.',
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
              child: Text('Start Now', style: TextStyle(color: Colors.white)),
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
              Image.network(
                'https://th.bing.com/th/id/R.52313b752393e3416488437a79cd9589?rik=YzjnkuVQ%2bK%2bb1A&riu=http%3a%2f%2fclipart-library.com%2fimages_k%2fconfetti-clipart-transparent%2fconfetti-clipart-transparent-17.png&ehk=AbjkM7hY8P%2fvHjqKm65Z0kXhJMNyunaSemYgTqvGhOI%3d&risl=&pid=ImgRaw&r=0',
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
              child: Text(
                'Yes, Start Now',
                style: TextStyle(color: Colors.white),
              ),
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
