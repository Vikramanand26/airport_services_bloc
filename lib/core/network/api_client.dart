// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client client;

  ApiClient({required this.client});

  Future<dynamic> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        message: 'Failed to fetch data. Status code: ${response.statusCode}',
      );
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        message: 'Failed to post data. Status code: ${response.statusCode}',
      );
    }
  }
}