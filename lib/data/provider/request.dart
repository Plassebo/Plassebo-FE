import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plassebo_flutter/data/model/post_nearby.dart';

void postMultipart(File img, String uri, Function setData) async {
  final parseUri = Uri.parse(uri);
  var request = http.MultipartRequest("POST", parseUri);

  request.files.add(await http.MultipartFile.fromPath("file", img.path));
  final res = await request.send();
  final result = await http.Response.fromStream(res);
  // debugPrint(result.body);
  final data = PostNearByResponse.fromJson(jsonDecode(result.body));
  setData(data);
}

Future<String> postQuestions(String uri, Map<String, String> data) async {
  debugPrint(jsonEncode(data).toString());
  final parseUri = Uri.parse(uri);
  debugPrint(parseUri.toString());

  final res = await http.post(parseUri,
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
      body: jsonEncode(data));
  debugPrint(res.body);

  return res.body;
}
