import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String responseText = '';
Map<String, List<String>> keywordsDict = {
  "greet": ["안녕", "안녕하세요", "하이"],
  "price": ["가격", "요금", "비용"],
  "time": ["영업시간", "영업", "시간", "운영시간", "운영", "오픈", "마감"],
  "phone": ["번호", "매장번호", "전화"],
  "address": ["주소", "위치", "어디", "어딘지"],
};

void getResponse(String inputString) async {
  List<String> restaurants = [];
  String restName = "";

  FirebaseFirestore.instance
      .collection('restaurants')
      .get()
      .then((querySnapshot) {
    // restaurants.clear();

    querySnapshot.docs.forEach((doc) {
      String data = doc['name'];
      restaurants.add(data);
    });

    debugPrint(restaurants[0]);

    for (final r in restaurants) {
      if (inputString.contains(r)) {
        restName = r;
        break;
      }
    }

    Map<String, String> responses = {
      "greet": "안녕하세요, 무엇을 도와드릴까요?",
      "price": "$restName의 가격 정보입니다.",
      "time": "$restName의 영업 시간 정보입니다.",
      "phone": "$restName의 매장 번호입니다.",
      "address": "$restName의 주소입니다.",
      "fallback": "없는 정보입니다.",
      "default": "$restName의 가게 정보입니다.",
    };

    List<String> matchedIntent = [];
    List<String> key = [];
    for (String intent in keywordsDict.keys) {
      for (String keyword in keywordsDict[intent]!) {
        debugPrint(keyword);
        if (inputString.contains(keyword)) {
          matchedIntent.add(intent);
          break; // Stop checking other keywords for this intent if one is matched.
        }
      }
    }

    for (String mi in matchedIntent) {
      if (responses.containsKey(mi)) {
        key.add(mi);
      }
    }

    if (restName == "" && !key.contains("greet")) {
      key.add("fallback");
    } else if (key.isEmpty) {
      key.add("default");
    }
    debugPrint(key.toString());

    responseText = responses[key.first]!;

    FirebaseFirestore.instance
        .collection("chat")
        .add({'text': responseText, 'time': Timestamp.now(), 'isUser': false});
  });
}
