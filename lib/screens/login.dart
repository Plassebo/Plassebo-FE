import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인'), backgroundColor: Color(0xFF4A7DFF)),
      body: Center(
        child: Text(
          '로그인 페이지',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
