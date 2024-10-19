import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model.dart';

Future<List<Move>> fetchLeads() async {
  final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Check if the 'data' field is present and not null
    if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
      List<dynamic> data = jsonResponse['data'];
      return data.map((json) => Move.fromJson(json)).toList();
    } else {
      // If 'data' is null or not a List, return an empty list
      return [];
    }
  } else {
    throw Exception('Failed to load leads');
  }
}
//
// Future<List<Lead>> fetchLeads() async {
//   final response = await http.get(Uri.parse('http://test.api.boxigo.in/sample-data/'));
//
//   if (response.statusCode == 200) {
//     // Print the full response for debugging
//     print(response.body);
//
//     final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//
//     if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
//       List<dynamic> data = jsonResponse['data'];
//       return data.map((json) => Lead.fromJson(json)).toList();
//     } else {
//       return [];
//     }
//   } else {
//     throw Exception('Failed to load leads');
//   }
// }

