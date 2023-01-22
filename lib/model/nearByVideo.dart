import 'trendingVideoModel.dart';

class NearByVideos {
  String? msg;
  List<TrendingData>? data;
  bool? success;

  NearByVideos({this.msg, this.data, this.success});

  NearByVideos.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TrendingData>[];
      json['data'].forEach((v) {
        data!.add(TrendingData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class User {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  int? isCommentBlock;

  User(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.isCommentBlock});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    isCommentBlock = json['isCommentBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['imagePath'] = imagePath;
    data['isFollowing'] = isFollowing;
    data['isRequested'] = isRequested;
    data['isCommentBlock'] = isCommentBlock;
    return data;
  }
}
