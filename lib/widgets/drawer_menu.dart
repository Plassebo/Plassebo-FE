import 'package:flutter/material.dart';

// 드로어 메뉴 위젯
class DrawerMenu extends StatefulWidget {
  final Function(int) onItemTapped;

  DrawerMenu({required this.onItemTapped});
  @override
  State<DrawerMenu> createState() =>
      _DrawerMenuState(onItemTapped: onItemTapped);
}

class _DrawerMenuState extends State<DrawerMenu> {
  final Function(int) onItemTapped;

  _DrawerMenuState({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4A7DFF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //       'assets/profile_image.png'), // 프로필 이미지
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '부산 알리미',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('홈 화면'),
            onTap: () {
              onItemTapped(-1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_outlined),
            title: Text('주변 맛집 리스트'),
            onTap: () {
              onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.mark_chat_unread_outlined),
            title: Text('부알봇 채팅'),
            onTap: () {
              onItemTapped(2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
