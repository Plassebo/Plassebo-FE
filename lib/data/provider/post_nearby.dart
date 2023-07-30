import 'package:flutter/material.dart';
import 'package:plassebo_flutter/data/model/post_nearby.dart';
import 'package:plassebo_flutter/data/provider/request.dart';

postNearby(String img) async {
  final res = await post(
      "http://localhost:8080/images", PostNearbyModel(img: img).toJson());
  debugPrint(res.toString());
  return res;
}
