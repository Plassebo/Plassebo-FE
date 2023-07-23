import 'package:flutter/material.dart';

class Chatting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerScreen();
  }
}

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreen createState() => _ContainerScreen();
}

class _ContainerScreen extends State<ContainerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChattingScreen(),
    Page1Screen(),
    Page2Screen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '부산알리미',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DFF),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pageview),
              label: '페이지 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pageview),
              label: '페이지 2',
            ),
          ],
          backgroundColor: Color(0xFF4A7DFF),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70),
    );
  }
}

// 드로어 메뉴 위젯
class DrawerMenu extends StatelessWidget {
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
                  '사용자 프로필',
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
            title: Text('홈'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.pageview),
            title: Text('페이지 1'),
            onTap: () {
              Navigator.pushNamed(context, '/page1');
            },
          ),
          ListTile(
            leading: Icon(Icons.pageview),
            title: Text('페이지 2'),
            onTap: () {
              Navigator.pushNamed(context, '/page2');
            },
          ),
        ],
      ),
    );
  }
}

class ChattingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "해운대 맛집",
                style: TextStyle(
                    color: Color(0xFF797979),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFDCE6FF),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Text("만원대 점심 먹기 좋은 곳 있니?",
                    style: TextStyle(fontSize: 16, color: Color(0xFF292929))),
              )
            ],
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF749BFF),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("저도 잘 모르겠어요",
                      style:
                          TextStyle(fontSize: 16, color: Color(0xFF292929)))),
            ],
          ),
        ],
      ),
    );
  }
}

// 페이지 1 화면
class Page1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('페이지 1'),
    );
  }
}

// 페이지 2 화면
class Page2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('페이지 2'),
    );
  }
}

// 설정 페이지
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Center(
        child: Text('설정 페이지'),
      ),
    );
  }
}
