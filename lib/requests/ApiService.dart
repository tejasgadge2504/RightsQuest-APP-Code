import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://74c1-34-87-157-88.ngrok-free.app"; // Use the correct API URL
  static String? csrfToken;

  Future<void> fetchCsrfToken() async {
    final response = await http.get(Uri.parse('$apiUrl/csrf-token/'));
    if (response.statusCode == 200) {
      csrfToken = response.headers['x-csrf-token'];
      if (csrfToken == null) {
        throw Exception('CSRF token not found in the response');
      }
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

  Future<Map<String, dynamic>> fetchQuizData(String rightName) async {
    if (csrfToken == null) {
      await fetchCsrfToken();
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-CSRFToken': csrfToken!,
        },
        body: jsonEncode({'rightName': rightName}),
      );

      if (response.statusCode == 200) {
        var responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response from the server');
        }
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to load quiz data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching quiz data: $e');
    }
  }
}
