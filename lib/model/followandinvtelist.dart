class FollowAndInviteList {
  String? msg;
  List<FollowInviteData>? data;
  bool? success;

  FollowAndInviteList({this.msg, this.data, this.success});

  FollowAndInviteList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <FollowInviteData>[];
      json['data'].forEach((v) {
        data!.add(FollowInviteData.fromJson(v));
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

class FollowInviteData {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;
  String? followersCount;

  FollowInviteData(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.imagePath,
      this.followersCount});

  FollowInviteData.fromJson(Map<String, dynamic> json) {
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
