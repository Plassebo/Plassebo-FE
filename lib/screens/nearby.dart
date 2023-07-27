import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:plassebo_flutter/data/model/post_nearby.dart';
import 'package:plassebo_flutter/data/provider/request.dart';
import 'package:plassebo_flutter/widgets/header.dart';
import 'package:plassebo_flutter/widgets/footer.dart';
import 'package:plassebo_flutter/widgets/drawer_menu.dart';
import 'package:plassebo_flutter/screens/myinfo.dart';
import 'package:plassebo_flutter/screens/favorites.dart';

import 'package:provider/provider.dart';

class NearBy extends StatelessWidget {
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
    ContainerScreen(),
    ContainerScreen(),
    MyInfo(),
    Favorites(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PostNearByResponse data = PostNearByResponse();

  void setData(PostNearByResponse model) {
    setState(() {
      data = model;
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("post multipart start...");
    postMultipart("/Users/nykoh/git/Plassebo-FE/assets/haewoondae.png",
        "http://localhost:8080/images", setData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: DrawerMenu(),
      body: NearByScreen(
        location: data.attractionName,
        restaurantList: data.restaurants,
      ),
      bottomNavigationBar: Footer(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          pages: _pages),
    );
  }
}

class NearByScreen extends StatelessWidget {
  final String location;
  final List<dynamic> restaurantList;
  NearByScreen({required this.location, required this.restaurantList});
  @override
  Widget build(BuildContext context) {
    debugPrint(restaurantList.toString());

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        WallPaper(img: "assets/haewoondae.png", location: location),
        RestaurantContainer(
          location: location,
          restaurantList: restaurantList
              .map((rest) => RestaurantItem(
                    title: rest['title'],
                    foodType: "한식",
                    address: rest['addr1'] == null ? "" : rest['addr1'],
                    telephone: rest['tel'],
                    imgUri:
                        rest['firstimage'] == null ? "" : rest['firstimage'],
                  ))
              .toList(),
        )
      ],
    );
  }
}

class WallPaper extends StatelessWidget {
  final String img;
  final String location;

  const WallPaper({required this.img, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF4A7DFF),
      height: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(30),
      child: Row(children: [
        Image.asset(
          img,
          width: 210,
          height: 190,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "나의 위치",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              Text("현재 나의 위치는",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
              SizedBox(
                height: 5,
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    location,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  // Text(" 입니다.",
                  //     style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 16)),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}

class RestaurantContainer extends StatelessWidget {
  final String location;
  final List<Widget> restaurantList;
  const RestaurantContainer(
      {required this.location, required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.67,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          children: [
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD)))),
              child: RestaurantHeader(
                location: location,
              ),
            ),
            RestaurantItemList(restaurantList: restaurantList),
          ],
        ),
      ),
    );
  }
}

class RestaurantHeader extends StatelessWidget {
  final String location;
  const RestaurantHeader({
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Text("$location 맛집",
        style: TextStyle(
            color: Color(0xFF797979),
            fontWeight: FontWeight.w600,
            fontSize: 25));
  }
}

class RestaurantItemList extends StatelessWidget {
  final List<Widget> restaurantList;
  const RestaurantItemList({required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: restaurantList,
      ),
    );
  }
}

class RestaurantItem extends StatelessWidget {
  final String title;
  final String foodType;
  final String address;
  final String telephone;
  final String imgUri;
  const RestaurantItem(
      {required this.title,
      required this.foodType,
      required this.address,
      required this.telephone,
      required this.imgUri});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD)))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: [
          Image.asset(
            "assets/galbi.png",
            height: 140,
            width: 140,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        child: Text(title,
                            style: TextStyle(
                                color: Color(0xFF515151),
                                fontWeight: FontWeight.w600,
                                fontSize: 20))),
                    SizedBox(
                      width: 70,
                    ),
                    SizedBox(
                        child: Text(foodType,
                            style: TextStyle(
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w500,
                                fontSize: 18)))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 230,
                  child: Flexible(
                    child: Text(
                      address,
                      style: TextStyle(
                          color: Color(0xFF797979),
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(telephone,
                    style: TextStyle(
                        color: Color(0xFF797979),
                        fontWeight: FontWeight.w500,
                        fontSize: 16))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
