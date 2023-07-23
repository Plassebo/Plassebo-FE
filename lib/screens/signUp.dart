import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입'), backgroundColor: Color(0xFF4A7DFF)),
      body: Center(
        child: Text(
          '회원가입 페이지',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
