import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ARVRPage extends StatefulWidget {
  @override
  _ARVRPageState createState() => _ARVRPageState();
}

class _ARVRPageState extends State<ARVRPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? spiderNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Spider Model")),
      body: ARView(onARViewCreated: onARViewCreated),
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

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: true,
    );
    arObjectManager.onInitialize();

    // Tap to place model
    arSessionManager.onPlaneOrPointTap = onPlaneTap;
  }

  Future<void> onPlaneTap(List<ARHitTestResult> hitTestResults) async {
    final hit = hitTestResults.firstWhere(
      (hit) => hit.type == ARHitTestResultType.plane,
      orElse: () => hitTestResults.first,
    );

    // extract translation and rotation from the hit test transform
    hit.worldTransform.getTranslation();
    // get rotation matrix and convert to quaternion
    final rotMatrix = hit.worldTransform.getRotation();
    final quaternion = Quaternion.fromRotation(rotMatrix);
    spiderNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/Spider.glb",
      rotation: Vector4(quaternion.x, quaternion.y, quaternion.z, quaternion.w),
    );

    bool? didAdd = await arObjectManager.addNode(spiderNode!);
    if (!didAdd!) {
      print("Failed to add the 3D model.");
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}
