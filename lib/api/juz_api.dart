import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:project_praktikum/model/juz_model.dart';

Future<Map<String, dynamic>> getJuz(int number) async {

  final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/juz/$number'));
  debugPrint("GetJuz - response : ${response.body}");

  return (_processResponseJuz(response));
}

Future<Map<String, dynamic>> _processResponseJuz(
  http.Response response) async {
    if(response.statusCode == 200) {
      final body = response.body;
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      throw Exception("Failed to load Ayahs");
    }
}

Future<Map<String, dynamic>> getTrans(int number) async {

  final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/juz/$number/en.asad'));
  debugPrint("GetTrans - response : ${response.body}");

  return (_processResponseTrans(response));
}

Future<Map<String, dynamic>> _processResponseTrans(
    http.Response response) async {
  if(response.statusCode == 200) {
    final body = response.body;
    final jsonBody = json.decode(body);
    return jsonBody;
  } else {
    throw Exception("Failed to load Trans");
  }
}