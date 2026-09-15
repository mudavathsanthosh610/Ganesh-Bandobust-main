import 'dart:convert';

import 'package:http/http.dart' as http;

class PlaceApiService {
  static const String _baseUrl =
      'https://policeportal.tspolice.gov.in/ganesh/getGanaDetails';

  static Future<Map<String, dynamic>> fetchPlaceDetails(
    String applicationId,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$applicationId'),
      headers: const {
        'Content-Type': 'application/json',
      },
      body: '{}',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Place API failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      return Map<String, dynamic>.from(decoded.first as Map);
    }

    throw const FormatException('Unexpected place API response.');
  }
}