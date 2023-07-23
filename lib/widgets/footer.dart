import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> pages;

  Footer(
      {required this.selectedIndex,
      required this.onItemTapped,
      required this.pages});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '내 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: '위치 촬영',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: '즐겨찾기',
          ),
        ],
        backgroundColor: Color(0xFF4A7DFF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70);
  }
}
