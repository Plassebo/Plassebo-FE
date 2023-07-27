import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plassebo_flutter/data/model/post_nearby.dart';

Future<http.Response> post(String uri, Map<String, dynamic> data) async {
  final parseUri = Uri.parse(uri);
  final res = await http.post(parseUri, body: data);
  debugPrint(res.toString());
  return res;
}

void postMultipart(String imgPath, String uri, Function setData) async {
  final parseUri = Uri.parse(uri);
  var request = http.MultipartRequest("POST", parseUri);

  request.files.add(await http.MultipartFile.fromPath("file", imgPath));

  final res = await request.send();
  final result = await http.Response.fromStream(res);

  // debugPrint(result.body);
  final data = PostNearByResponse.fromJson(jsonDecode(result.body));
  setData(data);
}
