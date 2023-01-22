class SearchedData {
  String? msg;
  Data? data;
  bool? success;

  SearchedData({this.msg, this.data, this.success});

  SearchedData.fromJson(Map<String, dynamic> json) {
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
  List<Creators>? creators;
  List<Hashtags>? hashtags;

  Data({this.creators, this.hashtags});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(Creators.fromJson(v));
      });
    }
    if (json['hashtags'] != null) {
      hashtags = <Hashtags>[];
      json['hashtags'].forEach((v) {
        hashtags!.add(Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (creators != null) {
      data['creators'] = creators!.map((v) => v.toJson()).toList();
    }
    if (hashtags != null) {
      data['hashtags'] = hashtags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Creators {
  int? id;
  String? image;
  String? name;
  String? userId;
  int? isYou;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;
  int? isBlock;

  Creators(
      {this.id,
        this.image,
        this.name,
        this.userId,
        this.isYou,
        this.imagePath,
        this.isFollowing,
        this.isRequested,
        this.followersCount,
        this.isBlock});

  Creators.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    userId = json['user_id'];
    isYou = json['isYou'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
    isBlock = json['isBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['user_id'] = userId;
    data['isYou'] = isYou;
    data['imagePath'] = imagePath;
    data['isFollowing'] = isFollowing;
    data['isRequested'] = isRequested;
    data['followersCount'] = followersCount;
    data['isBlock'] = isBlock;
    return data;
  }
}

class Hashtags {
  String? tag;
  dynamic use;

  Hashtags({this.tag, this.use});

  Hashtags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    use = json['use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['use'] = use;
    return data;
  }
}
