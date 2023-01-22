class OwnFollowersFollowing {
  String? msg;
  Data? data;
  bool? success;

  OwnFollowersFollowing({this.msg, this.data, this.success});

  OwnFollowersFollowing.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  List<Followers>? followers;
  List<Followings>? followings;

  Data({this.followers, this.followings});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(Followers.fromJson(v));
      });
    }
    if (json['followings'] != null) {
      followings = <Followings>[];
      json['followings'].forEach((v) {
        followings!.add(Followings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (followers != null) {
      data['followers'] = followers!.map((v) => v.toJson()).toList();
    }
    if (followings != null) {
      data['followings'] = followings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;
  String? followersCount;
  int? isFollowing;

  Followers(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.imagePath,
      this.followersCount,
      this.isFollowing});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    imagePath = json['imagePath'];
    followersCount = json['followersCount'];
    isFollowing = json['isFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['image'] = image;
    data['imagePath'] = imagePath;
    data['followersCount'] = followersCount;
    data['isFollowing'] = isFollowing;
    return data;
  }
}

class Followings {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;
  String? followersCount;

  Followings(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.imagePath,
      this.followersCount});

  Followings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    imagePath = json['imagePath'];
    followersCount = json['followersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['image'] = image;
    data['imagePath'] = imagePath;
    data['followersCount'] = followersCount;
    return data;
  }
}
