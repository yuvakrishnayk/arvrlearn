import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Add this import

class ARVRPage extends StatefulWidget {
  final String name;
  final String path;

  const ARVRPage({Key? key, required this.name, required this.path})
    : super(key: key);

  @override
  State<ARVRPage> createState() => _ARVRPageState();
}

class _ARVRPageState extends State<ARVRPage> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _micController;

  // Educational platform color scheme
  final Color _primaryColor = const Color(0xFF1565C0); // Education blue
  final Color _accentColor = const Color(0xFF26A69A); // Teal accent
  final Color _backgroundColor = const Color(
    0xFFF5F9FC,
  ); // Light educational bg
  final Color _cardColor = Colors.white;
  final Color _textDarkColor = const Color(0xFF2D3B45); // Deep educational text
  final Color _textLightColor = const Color(0xFF6B7780); // Secondary text

  // Learning controls color palette
  final Color _controlPanelBg = const Color(0xFF2D3B45).withOpacity(0.9);
  final Color _speakButtonColor = const Color(0xFF26A69A); // Teal for speech
// Orange for reset
  final Color _homeButtonColor = const Color(0xFF5C6BC0); // Indigo for home
  final Color _micActiveColor = const Color(0xFF66BB6A); // Green for active
  final Color _micInactiveColor = const Color(0xFFEF5350); // Red for inactive

  // Add TTS engine
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  
  // Description to be read
  final String brainDescription = 
    'This detailed neuroanatomical model reveals the complex structures of the human brain. '
    'The cerebral hemispheres include the frontal lobe, responsible for personality and decision-making, '
    'the parietal lobe, which processes sensory information, '
    'the temporal lobe for auditory processing and memory formation, '
    'and the occipital lobe for visual processing. '
    'The brain stem controls basic life functions like breathing and heart rate, '
    'while the cerebellum coordinates movement and balance.';

  @override
  void initState() {
    super.initState();
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Initialize TTS
    initTts();
  }
  
  void initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); // Slower rate for educational content
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    _micController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      setState(() {
        isSpeaking = true;
      });
      
      // Show a snackbar to indicate speaking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Explaining about the brain...', style: GoogleFonts.poppins()),
          backgroundColor: _speakButtonColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      
      await flutterTts.speak(brainDescription);
    }
  }

  // Placeholder for voice command handler
  void _handleVoiceCommand() {
    // TODO: Implement voice command functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice command feature coming soon!', style: GoogleFonts.poppins()),
        backgroundColor: _micInactiveColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _controlPanelBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(
              icon: Icons.school_rounded,
              label: "Back",
              onPressed: () => Navigator.pop(context),
              color: _homeButtonColor,
            ),
            
            
            const SizedBox(width: 20),
            _buildControlButton(
              icon: isSpeaking ? Icons.stop_rounded : Icons.record_voice_over_rounded,
              label: isSpeaking ? "Stop" : "Explain",
              onPressed: () => _speak(brainDescription),
              color: _speakButtonColor,
            ),
            const SizedBox(width: 20),
            _buildControlButton(
              icon: _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              label: "Ask",
              onPressed: _handleVoiceCommand,
              color: _isListening ? _micActiveColor : _micInactiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.9), color],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPressed,
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                ),
              ),
              if (label == "Ask" && _isListening)
                ScaleTransition(
                  scale: _micController,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "${widget.name}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: _primaryColor.withOpacity(0.95),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        "Learning Guide",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.touch_app,
                                color: _primaryColor,
                              ),
                              title: Text(
                                "Interact with the model",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Touch and drag to rotate. Pinch to zoom in and out.",
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.record_voice_over,
                                color: _speakButtonColor,
                              ),
                              title: Text(
                                "Learn by listening",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Tap 'Explain' to hear about this model.",
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.mic, color: _micActiveColor),
                              title: Text(
                                "Ask questions",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Tap 'Ask' and speak your question about the model.",
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Got it",
                            style: GoogleFonts.poppins(color: _primaryColor),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Learning objectives card
                    Card(
                      elevation: 3,
                      color: _cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: _primaryColor.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: _accentColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Learning Objectives',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildLearningObjective(
                              "Understand the structure and components of ${widget.name}",
                              Icons.check_circle_outline,
                            ),
                            _buildLearningObjective(
                              "Identify key features through 3D visualization",
                              Icons.check_circle_outline,
                            ),
                            _buildLearningObjective(
                              "Explore the model from different angles",
                              Icons.check_circle_outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3D Model Card - Interactive learning tool
                    Card(
                      elevation: 4,
                      color: _cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: _primaryColor.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.view_in_ar_rounded,
                                  color: _primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Interactive Learning Model',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: _primaryColor,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.shade50,
                                    Colors.grey.shade100,
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ModelViewer(
                                  src: widget.path,
                                  alt: 'Educational 3D model of ${widget.name}',
                                  autoRotate: true,
                                  cameraControls: true,
                                  ar: true,
                                  arModes: [
                                    'scene-viewer',
                                    'webxr',
                                    'quick-look',
                                  ],
                                  shadowIntensity: 1,
                                  backgroundColor: const Color.fromARGB(
                                    0xFF,
                                    0xF8,
                                    0xF9,
                                    0xFA,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Learning instructions
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _accentColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _accentColor.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.touch_app_rounded,
                                        color: _accentColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'How to interact:',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _textDarkColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Tap and drag to rotate the model\n• Pinch or scroll to zoom in and out\n• Double-tap to reset the view',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: _textLightColor,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // About Model Card - Educational context
                    // Within the 'Learning Material' Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About ${widget.name}',
                            style: GoogleFonts.poppins(
                              color: _textDarkColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This detailed neuroanatomical model reveals the complex structures of the human brain. Explore:\n\n'
                            '• Cerebral hemispheres with color-coded lobes (frontal, parietal, temporal, occipital)\n'
                            '• Brainstem components: midbrain, pons, and medulla oblongata\n'
                            '• Cerebellar anatomy and vermis structure\n'
                            '• Limbic system structures including hippocampus and amygdala\n'
                            '• Ventricular system and basal ganglia organization\n\n'
                            'The model highlights functional neuroanatomy with interactive dissection capabilities, showing neural pathways '
                            'and blood supply through the Circle of Willis.',
                            style: GoogleFonts.poppins(
                              color: _textDarkColor,
                              fontSize: 14,
                              height: 1.6,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Educational Resource Details',
                            style: GoogleFonts.poppins(
                              color: _textDarkColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                _buildResourceInfo(
                                  'Model Type',
                                  'Dissectible Neuroanatomy',
                                  Icons.psychology_rounded,
                                ),
                                const Divider(height: 16),
                                _buildResourceInfo(
                                  'Detail Level',
                                  'Medical Education Standard',
                                  Icons.school_rounded,
                                ),
                                const Divider(height: 16),
                                _buildResourceInfo(
                                  'Source',
                                  'Visible Human Project Dataset',
                                  Icons.dataset_rounded,
                                ),
                                const Divider(height: 16),
                                _buildResourceInfo(
                                  'Annotations',
                                  '200+ Structural Labels',
                                  Icons.label_rounded,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add extra space at the bottom for the control panel
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Control Panel
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: _buildControlPanel(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for educational UI components
  Widget _buildLearningObjective(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _textDarkColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _textLightColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: _textDarkColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 13, color: _textLightColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
