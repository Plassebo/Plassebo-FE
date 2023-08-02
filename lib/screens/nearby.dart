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

import 'package:extended_image/extended_image.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
  PostNearByResponse data = PostNearByResponse();

  Image image = Image.network(
      "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg");

  void setData(PostNearByResponse model) {
    setState(() {
      data = model;
    });
  }

  Future<String> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    // final XFile? pickedFile =
    //     await picker.pickImage(source: ImageSource.gallery);
    try {
      final XFile? photo =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      // 카메라로 찍어서
      if (photo != null) {
        return photo.path;
      }
      return "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  void takePicture() async {
    final String filePath = await pickAndUploadImage();
    postMultipart(File(filePath), "http://34.22.67.47:8080/images", setData);
    setState(() {
      image = Image.file(File(filePath),
          width: 180, height: 160, fit: BoxFit.cover);
    });
    debugPrint("take picture done");
  }

  @override
  void initState() {
    super.initState();
    takePicture();
  }

  @override
  Widget build(BuildContext context) {
    return NearByScreen(
        location: data.attractionName,
        restaurantList: data.restaurants,
        image: image);
  }
}

class NearByScreen extends StatelessWidget {
  final String location;
  final List<dynamic> restaurantList;
  final Image image;

  NearByScreen(
      {required this.location,
      required this.restaurantList,
      required this.image});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        WallPaper(img: image, location: location),
        RestaurantContainer(
          location: location,
          restaurantList: restaurantList.isEmpty
              ? [Text("주변 맛집이 없습니다.")]
              : restaurantList
                  .map((rest) => RestaurantItem(
                      title: rest['title'],
                      address: rest['addr1'] ?? "",
                      telephone: rest['tel'],
                      imgUri: rest['firstimage'] ??
                          "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                      info: rest['info'] ?? "",
                      time: rest['time'] ?? Map<String, dynamic>(),
                      distance: rest['distance']))
                  .toList(),
        )
      ],
    );
  }
}

class WallPaper extends StatelessWidget {
  final Image img;
  final String location;

  const WallPaper({required this.img, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF4A7DFF),
      height: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ClipRRect(borderRadius: BorderRadius.circular(10.0), child: img),
        SizedBox(
          width: 140,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            runSpacing: 5,
            children: [
              Text(
                "나의 위치",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              SizedBox(
                height: 43,
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
                  Text("입니다.",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ],
              )
            ],
          ),
        ),
      ]),
      // ),
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

class RestaurantItem extends StatefulWidget {
  final String title;
  final String address;
  final String telephone;
  final String imgUri;
  final String info;
  final Map<String, dynamic> time;
  final double distance;
  RestaurantItem(
      {required this.title,
      required this.address,
      required this.telephone,
      required this.imgUri,
      required this.info,
      required this.time,
      required this.distance});

  @override
  State<RestaurantItem> createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed;
        });
      },
      child: Column(
        children: [
          BasicInfo(
              imgUri: widget.imgUri,
              title: widget.title,
              distance: widget.distance,
              address: widget.address,
              telephone: widget.telephone),
          if (isPressed && (widget.time.isNotEmpty || widget.info.isNotEmpty))
            Column(children: [
              if (widget.time.isNotEmpty)
                ExpansionTile(
                    title: Text("영업 시간"),
                    children: widget.time.entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(runSpacing: 4, children: [
                                Text(e.key),
                                Text(" : "),
                                Text(e.value)
                              ]),
                            ))
                        .toList()),
              if (widget.info.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    runSpacing: 6,
                    children: [
                      Text("추가 정보 : ",
                          style: TextStyle(
                              color: Color(0xFF555555), fontSize: 16)),
                      Text(widget.info),
                    ],
                  ),
                ),
            ]),
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFDDDDDD),
          ),
        ],
      ),
    );
  }
}

class BasicInfo extends StatelessWidget {
  const BasicInfo({
    super.key,
    required this.imgUri,
    required this.title,
    required this.distance,
    required this.address,
    required this.telephone,
  });

  final String imgUri;
  final String title;
  final double distance;
  final String address;
  final String telephone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ExtendedImage.network(
              imgUri,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
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
                        width: 135,
                        child: Flexible(
                          child: Text(title,
                              style: TextStyle(
                                color: Color(0xFF515151),
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              )),
                        )),
                    SizedBox(
                        child: Text(distance.toString().substring(0, 3) + "km",
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
                  width: 190,
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
