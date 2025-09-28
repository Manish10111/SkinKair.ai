import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadEnv() async {
  final String response = await rootBundle.loadString('env.json');
  return json.decode(response) as Map<String, dynamic>;
}