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
    return SizedBox(
      height: 120,
      child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: <BottomNavigationBarItem>[
            if (false)
              BottomNavigationBarItem(
                  icon: Icon(Icons.abc), label: "it will be disappear..."),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '내 정보',
            ),
            BottomNavigationBarItem(
                backgroundColor: Color(0xFF4A7DFF),
                icon: CustomNavigationBarItem(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFFFFFFFF),
                  ),
                  label: '위치 촬영',
                ),
                label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_outlined),
              label: '즐겨찾기',
            ),
          ],
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54),
    );
  }
}

class CustomNavigationBarItem extends StatelessWidget {
  final Icon icon;
  final String label;

  CustomNavigationBarItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF4A7DFF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            width: 12,
          ),
          Text(
            label,
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}