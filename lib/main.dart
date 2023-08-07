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
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home(),
        '/nearby': (context) => NearBy(isCamera: true),
        '/chatting': (context) => Chatting(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _visible = true;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _visible = false;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pushNamed(context, '/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        child: Container(
          color: Color(0xFFFFFFFF),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/main_logo.png",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
