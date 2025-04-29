import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.137.126:5000/api';

  static Future<VoiceResponse> sendVoice(File audioFile) async {
    try {
      // Verify file exists and has content
      if (!await audioFile.exists()) {
        throw ApiException('Audio file does not exist');
      }
      final fileSize = await audioFile.length();
      if (fileSize == 0) {
        throw ApiException('Audio file is empty');
      }

      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/voice'));
      request.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          audioFile.path,
          contentType: MediaType('audio', 'wav'),
        ),
      );

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return VoiceResponse.fromJson(json.decode(responseBody));
      } else {
        throw ApiException(
          'Server error: ${response.statusCode} - $responseBody',
        );
      }
    } catch (e) {
      throw ApiException('Voice processing failed: ${e.toString()}');
    }
  }

  // [Rest of your existing ApiService code...]
}

class VoiceResponse {
  final String text;
  final String response;
  final bool success;

  VoiceResponse({
    required this.text,
    required this.response,
    required this.success,
  });

  factory VoiceResponse.fromJson(Map<String, dynamic> json) {
    return VoiceResponse(
      text: json['text'] ?? '',
      response: json['response'] ?? 'No response',
      success: json['success'] ?? false,
    );
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
