import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plassebo_flutter/data/provider/request.dart';

String responseText = '';
String restName = "";
const String reqeustUrl = "http://34.22.67.47:8080/questions";

String makeResponse(String restaurantName, String type, dynamic info) {
  switch (type) {
    case "주소":
      return "${restaurantName}은(는) ${info}에 위치하고 있습니다.";
    case "전화번호":
      return "${restaurantName}의 매장 번호는 ${info}입니다.";
    case "영업시간":
      String times = "";
      for (var t in jsonDecode(info).entries) {
        times = "$times\n\n${t.key}:\n${t.value}";
      }
      return "${restaurantName}의 영업 시간은 아래와 같습니다.${times}";
    case "가격":
      dynamic entry = jsonDecode(info).entries.toList()[0];
      return "${restaurantName}의 대표 메뉴와 그 가격을 알려드릴게요.\n\n${restaurantName}의 대표 메뉴는 ${entry.key}이고, 그 가격은 ${entry.value}입니다.";
    case "기타":
      return "${restaurantName}의 추가 정보를 알려드릴게요.\n\n${info}";
    default:
      return "올바르지 않은 요청";
  }
}

Map<String, List<String>> keywordsDict = {
  "greet": ["안녕", "안녕하세요", "하이", "ㅎㅇ"],
  "price": ["가격", "요금", "비용", '4'],
  "time": ["영업시간", "영업", "시간", "운영시간", "운영", "오픈", "마감", "3"],
  "phone": ["번호", "매장번호", "전화", "2"],
  "address": ["주소", "위치", "어디", "어딘지", "1"],
  "etc": ["기타", "추가 정보", "추가", "정보", "5"]
};

void getResponse(String inputString) async {
  List<String> restaurants = [];
  String type = "";

  void setType(String key) async {
    switch (key) {
      case "greet":
        responseText = "안녕하세요, 무엇을 도와드릴까요?\n\n알고 싶은 가게의 이름을 입력해주세요!";
        break;

      case "price":
        type = "가격";
        break;

      case "time":
        type = "영업시간";
        break;

      case "phone":
        type = "전화번호";
        break;

      case "address":
        type = "주소";
        break;

      case "etc":
        type = "기타";
        break;
      case "fallback":
        responseText = "없는 정보입니다. 알고 싶은 가게의 이름을 입력해주세요!";
        break;
    }
  }

  FirebaseFirestore.instance
      .collection('restaurants')
      .get()
      .then((querySnapshot) {
    // restaurants.clear();

    querySnapshot.docs.forEach((doc) {
      String data = doc['name'];
      restaurants.add(data);
    });

    for (final r in restaurants) {
      if (inputString.contains(r)) {
        restName = r;
        FirebaseFirestore.instance.collection("chat").add({
          'text':
              "${restName}의 어떤 정보를 원하시나요?\n\n번호나 형식으로 입력해주세요!\n\n1. 주소\n2. 매장 번호\n3. 영업 시간\n4. 가격\n5. 추가 정보(기타)",
          'time': Timestamp.now(),
          'isUser': false
        });
        break;
      }
    }
  });

  List<String> matchedIntent = [];
  List<String> key = [];
  for (String intent in keywordsDict.keys) {
    for (String keyword in keywordsDict[intent]!) {
      if (inputString.contains(keyword)) {
        matchedIntent.add(intent);
        break; // Stop checking other keywords for this intent if one is matched.
      }
    }
  }

  for (String mi in matchedIntent) {
    if (keywordsDict.containsKey(mi)) {
      key.add(mi);
    }
  }
  for (var k in key) {
    setType(k);
    if (k == "greet" || k == "fallback") {
      FirebaseFirestore.instance.collection("chat").add(
          {'text': responseText, 'time': Timestamp.now(), 'isUser': false});
      restName = "";
      break;
    }
    String resString = await postQuestions("http://34.22.67.47:8080/questions",
        {"restaurantName": restName, "type": type});
    FirebaseFirestore.instance.collection("chat").add({
      'text': makeResponse(restName, type, resString),
      'time': Timestamp.now(),
      'isUser': false
    });
  }
}
