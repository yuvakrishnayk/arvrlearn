import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ARVRPage extends StatefulWidget {
  final String? name;
  final String? path;
  const ARVRPage({Key? key, this.name, this.path}) : super(key: key);

  @override
  ARVRPageState createState() => ARVRPageState();
}

class ARVRPageState extends State<ARVRPage> with TickerProviderStateMixin {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  ARNode? spiderNode;
  ARNode? appleNode;
  ARNode? handNode;

  // App configuration
  double appleScale = 0.2;
  bool isMovingApple = false;
  bool isLoading = true;

  // Voice features
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceText = '';

  // Animations
  late AnimationController _statusController;
  late AnimationController _micController;
  late AnimationController _textFadeController;
  late Animation<double> _textOpacity;
  String _statusMessage = "Initializing AR...";

  @override
  void initState() {
    super.initState();
    GoogleFonts.config.allowRuntimeFetching = true;
    _initializeTts();
    _initializeSpeech();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _statusController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _micController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _textFadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOut),
    );
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _initializeSpeech() async {
    _speech = stt.SpeechToText();
    await _requestMicrophonePermission();
    await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
  }

  Future<void> _requestMicrophonePermission() async {
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      _showStatus("Microphone access required for voice commands", duration: 3);
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    flutterTts.stop();
    _speech.stop();
    _statusController.dispose();
    _micController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  void _showStatus(String message, {int duration = 3}) {
    setState(() => _statusMessage = message);
    Future.delayed(Duration(seconds: duration), () {
      if (mounted && _statusMessage == message) {
        setState(() => _statusMessage = "");
      }
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
    _showStatus("Pronouncing: \"$text\"", duration: 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(Icons.view_in_ar, size: 24, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'AR Learning Experience',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: _showHelpDialog,
            ),
          ],
        ),
        body: Stack(
          children: [
            ARView(onARViewCreated: onARViewCreated),

            // Voice input text display
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child:
                    _voiceText.isNotEmpty
                        ? ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _textFadeController,
                            curve: Curves.easeOutBack,
                          ),
                          child: FadeTransition(
                            opacity: _textOpacity,
                            child: Center(
                              child: Container(
                                key: ValueKey<String>(_voiceText),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade800.withOpacity(0.9),
                                      Colors.blue.shade600.withOpacity(0.9),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _micController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale:
                                              _isListening
                                                  ? 1.0 +
                                                      _micController.value * 0.2
                                                  : 1.0,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.auto_awesome,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _voiceText,
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ),

            // Status indicator
            if (isLoading || _statusMessage.isNotEmpty)
              Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child:
                      _statusMessage.isNotEmpty
                          ? SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, -0.5),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _statusController,
                                curve: Curves.easeOutQuad,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _statusMessage.contains("error")
                                          ? Colors.red.shade700.withOpacity(
                                            0.95,
                                          )
                                          : Colors.green.shade700.withOpacity(
                                            0.95,
                                          ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isLoading
                                          ? Icons.autorenew
                                          : _statusMessage.contains("error")
                                          ? Icons.error_outline
                                          : Icons.check_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _statusMessage,
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
              ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _buildControlPanel(),
            ),

            if (isMovingApple) _buildMoveIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(
              icon: Icons.home,
              label: "Home",
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 16),
            _buildControlButton(
              icon: Icons.refresh,
              label: "Reset",
              onPressed: _resetApple,
            ),
            SizedBox(width: 16),
            _buildControlButton(
              icon: Icons.volume_up,
              label: "Speak",
              onPressed: () => _speak(widget.name ?? "Brain Model"),
              color: Colors.green.shade700,
            ),
            SizedBox(width: 16),
            _buildControlButton(
              icon: Icons.mic,
              label: "Ask",
              onPressed: _handleVoiceCommand,
              color: _isListening ? Colors.blue.shade700 : Colors.red.shade700,
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
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color ?? Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(icon, color: Colors.white),
                onPressed: onPressed,
              ),
              if (label == "Ask" && _isListening)
                ScaleTransition(
                  scale: _micController,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMoveIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app, size: 18),
              SizedBox(width: 8),
              Text("Tap where to place the model"),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.help),
                SizedBox(width: 10),
                Text('AR Interaction Guide'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHelpItem(Icons.touch_app, 'Tap model to select'),
                _buildHelpItem(Icons.pan_tool, 'Tap surface to place'),
                _buildHelpItem(Icons.volume_up, 'Tap speak for pronunciation'),
                _buildHelpItem(Icons.mic, 'Hold mic for voice commands'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
    );

    arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneTap;
    arObjectManager.onNodeTap = onNodeTapped;

    Future.delayed(const Duration(seconds: 1), () {
      _initializeSession();
    });
  }

  void _initializeSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        isLoading = false;
        _statusMessage = "Ready for interaction";
      });
    }
  }

  Future<void> _resetApple() async {
    if (spiderNode != null) {
      await arObjectManager.removeNode(spiderNode!);
      setState(() => spiderNode = null);
      _showStatus("Model position reset");
    }
  }

  void _handleVoiceCommand() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _voiceText = 'Listening...';
      });
      _textFadeController.stop();
      _textFadeController.reset();

      if (await _speech.initialize()) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _voiceText = result.recognizedWords;
              if (result.finalResult) {
                _processCommand(result.recognizedWords);
                _textFadeController.forward();
              }
            });
          },
          listenFor: const Duration(seconds: 5),
        );
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    _textFadeController.forward();
  }

  void _processCommand(String command) {
    final cleaned = command.toLowerCase();
    final modelName = widget.name?.toLowerCase() ?? "brain model";

    if (cleaned.contains('reset')) {
      _resetApple();
    } else if (cleaned.contains(modelName)) {
      _speak(widget.name ?? "Brain Model");
    } else if (cleaned.contains('move')) {
      setState(() => isMovingApple = true);
    }
    _showStatus(
      "Processed: ${command.length > 20 ? command.substring(0, 20) + '...' : command}",
    );
  }

  void _onSpeechStatus(String status) {
    if (status == 'done') _stopListening();
  }

  void _onSpeechError(error) {
    _stopListening();
    _showStatus("Voice error: ${error.errorMsg}");
  }

  Future<void> onPlaneTap(List<ARHitTestResult> hitTestResults) async {
    final hit = hitTestResults.firstWhere(
      (h) => h.type == ARHitTestResultType.plane,
      orElse: () => hitTestResults.first,
    );

    final translation = hit.worldTransform.getTranslation();
    final rotMatrix = hit.worldTransform.getRotation();
    final quat = Quaternion.fromRotation(rotMatrix);

    if (isMovingApple && spiderNode != null) {
      await arObjectManager.removeNode(spiderNode!);
    }

    spiderNode = ARNode(
      type: NodeType.localGLTF2,
      uri: widget.path ?? "assets/models/Brain.glb",
      position: Vector3(translation.x, translation.y, translation.z),
      scale: Vector3.all(0.2),
      rotation: Vector4(quat.x, quat.y, quat.z, quat.w),
    );

    // Create and add anchor only once
    final anchor = ARPlaneAnchor(transformation: hit.worldTransform);
    await arAnchorManager.addAnchor(anchor);

    // Debug to see if the node is being added
    print("Attempting to add 3D model at position: $translation");
    bool? didAdd = await arObjectManager.addNode(
      spiderNode!,
      planeAnchor: anchor,
    );

    if (didAdd != true) {
      _showStatus("Failed to add the 3D model");
      print("Failed to add the 3D model.");
    } else {
      _showStatus("Model placed successfully");
      print("Model added successfully");
      setState(() => isMovingApple = false);
    }
  }

  void onNodeTapped(List<String> nodes) {
    if (spiderNode != null && nodes.contains(spiderNode!.name)) {
      setState(() => isMovingApple = true);
      _showStatus("Move mode activated");
    }
  }
}
