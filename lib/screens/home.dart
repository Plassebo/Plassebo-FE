import 'package:flutter/material.dart';
import 'package:plassebo_flutter/widgets/footer.dart';
import 'package:plassebo_flutter/widgets/header.dart';
import 'package:plassebo_flutter/widgets/drawer_menu.dart';
import 'dart:async';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

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
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  TextEditingController _searchController = TextEditingController();

  List<LatLng> _searchResults = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _searchLocation() async {
    String query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색창에 위치를 입력해주세요!')),
      );
      return;
    }

    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(query);

    setState(() {
      _searchResults = locations.map((location) {
        return LatLng(location.latitude, location.longitude);
      }).toList();
    });
  }

  void _showMyLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위치 서비스를 활성화해주세요!')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('위치 권한을 허용해주세요!')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위치 권한이 영구적으로 거부되었습니다!')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng location = LatLng(position.latitude, position.longitude);
      setState(() {
        _searchResults = [location];
      });
    } catch (e) {
      print('위치를 가져오지 못했습니다: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치를 가져오지 못했습니다. 다시 시도해주세요!')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: DrawerMenu(),
      body: Stack(
        children: [
          NaverMap(
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            mapType: _mapType,
            markers: _buildMarkers(),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '위치 검색',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchLocation,
                  ),
                ),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 70,
              left: 16,
              right: 16,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '위도: ${_searchResults[index].latitude}, 경도: ${_searchResults[index].longitude}'),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: _showMyLocation,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4A7DFF),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
          ),
          child: Icon(Icons.my_location, size: 22, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Footer(
        onItemTapped: _onItemTapped,
        pages: [
          HomeScreen(),
          ContainerScreen(),
        ],
        selectedIndex: _selectedIndex,
      ),
    );
  }

  List<Marker> _buildMarkers() {
    return _searchResults.map((location) {
      return Marker(
        markerId: DateTime.now().toIso8601String(),
        position: location,
        captionText: '검색 결과',
      );
    }).toList();
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
