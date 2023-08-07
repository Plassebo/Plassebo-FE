import 'package:flutter/material.dart';

import 'package:plassebo_flutter/screens/home.dart';
import 'package:plassebo_flutter/screens/nearby.dart';

import 'package:plassebo_flutter/screens/chatting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // await dotenv.load(fileName: 'assets/config/.env');

    var currentFire = await FirebaseFirestore.instance.collection('chat').get();
    for (var item in currentFire.docs) {
      await item.reference.delete();
    }

    FirebaseFirestore.instance.collection('chat').add({
      'text': "안녕하세요, 부산 알리미 입니다.\n원하시는 가게의 상호명을 입력해주세요!",
      'time': Timestamp.now(),
      'isUser': false
    });

    runApp(MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      routes: {
        '/home': (context) => Home(),
        '/nearby': (context) => NearBy(isCamera: true),
        '/chatting': (context) => Chatting(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '부산 알리미',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A7DFF),
              ),
            ),
            SizedBox(height: 50),
            Text(
              '이미지 분류, 룰베이스 챗봇 기반 부산 맛집 정보 관광 앱',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDDDDDD),
              ),
            ),
            SizedBox(
              width: 160,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text(
                  '임시 메인 이동 버튼',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 94, 94, 94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
