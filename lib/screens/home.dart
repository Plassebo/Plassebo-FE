import 'package:flutter/material.dart';
import 'package:plassebo_flutter/widgets/footer.dart';
import 'package:plassebo_flutter/widgets/header.dart';
import 'package:plassebo_flutter/widgets/drawer_menu.dart';

// 네이버 지도 관련
import 'dart:async';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class Home extends StatelessWidget {
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

// 네이버 지도
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  final List<Widget> _pages = [
    HomeScreen(),
    ContainerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerMenu(),
        body: Container(
            child: NaverMap(
          onMapCreated: onMapCreated,
          mapType: _mapType,
        )),
        //body: _pages[_selectedIndex],
        bottomNavigationBar: Footer(
          onItemTapped: _onItemTapped,
          pages: _pages,
          selectedIndex: _selectedIndex,
        ));
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

// 홈 화면
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('홈 화면'),
    );
  }
}
