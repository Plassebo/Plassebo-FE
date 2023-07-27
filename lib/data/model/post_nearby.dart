class PostNearbyModel {
  late String img;

  PostNearbyModel({required this.img});

  PostNearbyModel.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['img'] = img;
    return data;
  }
}

class PostNearByResponse {
  late String attractionName = "";
  late List<dynamic> restaurants = [];

  // constructor
  PostNearByResponse();

  PostNearByResponse.fromJson(Map<String, dynamic> json) {
    attractionName = json['attractionName'];
    restaurants = json['restaurants'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['attractionName'] = attractionName;
    data['restaurants'] = restaurants;
    return data;
  }
}
