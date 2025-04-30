import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';

class ARVRPage extends StatefulWidget {
  final String name;
  final String path;
  final String description;
  final List<Map<String, String>> resourceDetails;

  const ARVRPage({
    Key? key,
    required this.name,
    required this.path,
    required this.description,
    required this.resourceDetails,
  }) : super(key: key);

  @override
  State<ARVRPage> createState() => _ARVRPageState();
}

class _ARVRPageState extends State<ARVRPage>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _micController;
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  // Added for voice recognition
  late stt.SpeechToText _speech;
  String _recognizedText = '';

  // Added for Gemini AI
  late GenerativeModel _geminiModel;
  String _aiResponse = '';
  final String _geminiApiKey =
      'AIzaSyACda_0LUjYMHEyHSj3NYFbDqml6EmebRo'; // Replace with your actual API key

  // Color scheme
  final Color _primaryColor = const Color(0xFF1565C0);
  final Color _accentColor = const Color(0xFF26A69A);
  final Color _backgroundColor = const Color(0xFFF5F9FC);
  final Color _cardColor = Colors.white;
  final Color _textDarkColor = const Color(0xFF2D3B45);
  final Color _textLightColor = const Color(0xFF6B7780);
  final Color _controlPanelBg = const Color(0xFF2D3B45).withOpacity(0.9);
  final Color _speakButtonColor = const Color(0xFF26A69A);
  final Color _homeButtonColor = const Color(0xFF5C6BC0);
  final Color _micActiveColor = const Color(0xFF66BB6A);
  final Color _micInactiveColor = const Color(0xFFEF5350);

  @override
  void initState() {
    super.initState();
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Initialize text-to-speech
    initTts();

    // Initialize speech recognition
    _speech = stt.SpeechToText();
    _initSpeech();

    // Initialize Gemini API
    _initGeminiAI();
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() => _isListening = false);
          _processRecognizedText();
        }
      },
      onError: (errorNotification) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Speech recognition error: ${errorNotification.errorMsg}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: _micInactiveColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Speech recognition not available on this device',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _micInactiveColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Initialize Gemini AI
  void _initGeminiAI() {
    try {
      _geminiModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to initialize Gemini AI: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _micInactiveColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      setState(() => isSpeaking = false);
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
      setState(() => isSpeaking = false);
    } else {
      setState(() => isSpeaking = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Explaining about ${widget.name}...',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _speakButtonColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      await flutterTts.speak(widget.description);
    }
  }

  // Process the recognized text with Gemini AI
  Future<void> _processRecognizedText() async {
    if (_recognizedText.isEmpty) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Processing: $_recognizedText',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      final content = [Content.text(_recognizedText)];
      final response = await _geminiModel.generateContent(content);

      setState(() {
        _aiResponse = response.text ?? "Sorry, I couldn't generate a response.";
      });

      // Speak the AI response
      _speakAiResponse(_aiResponse);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error getting AI response: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _micInactiveColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Speak the AI response
  Future<void> _speakAiResponse(String response) async {
    if (response.isEmpty) return;

    setState(() => isSpeaking = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'AI Response: ${response.length > 50 ? response.substring(0, 50) + '...' : response}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: _speakButtonColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    await flutterTts.speak(response);
  }

  void _handleVoiceCommand() async {
    if (_speech.isNotListening) {
      setState(() => _isListening = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Listening... Speak now!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _micActiveColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      await _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
              icon:
                  isSpeaking
                      ? Icons.stop_rounded
                      : Icons.record_voice_over_rounded,
              label: isSpeaking ? "Stop" : "Explain",
              onPressed: () => _speak(widget.description),
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

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Model Type':
        return Icons.psychology_rounded;
      case 'Detail Level':
        return Icons.school_rounded;
      case 'Source':
        return Icons.dataset_rounded;
      case 'Annotations':
        return Icons.label_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.name,
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
      ),
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
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Learning Objectives',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildLearningObjective(
                              "Understand the structure of ${widget.name}",
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
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Interactive Learning Model',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: _primaryColor,
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
                                  colors: [
                                    Colors.grey.shade50,
                                    Colors.grey.shade100,
                                  ],
                                ),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ModelViewer(
                                  src: widget.path,
                                  alt: '3D model of ${widget.name}',
                                  autoRotate: true,
                                  cameraControls: true,
                                  ar: true,
                                  arModes: [
                                    'scene-viewer',
                                    'webxr',
                                    'quick-look',
                                  ],
                                  shadowIntensity: 1,
                                  backgroundColor: const Color(0xFFF8F9FA),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                    '• Tap and drag to rotate\n• Pinch to zoom\n• Double-tap to reset',
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
                    Card(
                      elevation: 4,
                      color: _cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  color: _primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Learning Material',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
                                    widget.description,
                                    style: GoogleFonts.poppins(
                                      color: _textDarkColor,
                                      fontSize: 14,
                                      height: 1.6,
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
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < widget.resourceDetails.length;
                                          i++
                                        ) ...[
                                          _buildResourceInfo(
                                            widget.resourceDetails[i]['label']!,
                                            widget.resourceDetails[i]['value']!,
                                            _getIconForLabel(
                                              widget
                                                  .resourceDetails[i]['label']!,
                                            ),
                                          ),
                                          if (i !=
                                              widget.resourceDetails.length - 1)
                                            const Divider(height: 16),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
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
