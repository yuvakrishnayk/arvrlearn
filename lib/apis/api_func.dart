import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFunc {
  // Using localhost for local testing, change to your actual server IP when deploying
  final String _baseUrl =
      'https://learnedge-chatbot.onrender.com/generate'; // 10.0.2.2 points to host machine's localhost when running in Android emulator

  Future<String> generateResponse(String prompt) async {
    try {
      print('Sending request to API with prompt: $prompt');

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(
            const Duration(seconds: 30), // Set timeout to 30 seconds
            onTimeout: () {
              throw Exception(
                'Request timeout - server took too long to respond',
              );
            },
          );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? 'No response from model.';
      } else {
        String errorMessage;
        try {
          final error = jsonDecode(response.body);
          errorMessage = error['error'] ?? 'Unknown server error';
        } catch (e) {
          errorMessage = 'Server returned status code ${response.statusCode}';
        }
        print('API error: $errorMessage');
        return 'Error: $errorMessage';
      }
    } catch (e) {
      print('Exception in API call: $e');
      return 'Connection error: $e';
    }
  }
}
