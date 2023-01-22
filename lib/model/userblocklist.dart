class UserBlockList {
  String? msg;
  List<UserBlockListData>? data;
  bool? success;

  UserBlockList({this.msg, this.data, this.success});

  UserBlockList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <UserBlockListData>[];
      json['data'].forEach((v) {
        data!.add(UserBlockListData.fromJson(v));
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

class UserBlockListData {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? imagePath;

  UserBlockListData(
      {this.id, this.name, this.userId, this.image, this.imagePath});

  UserBlockListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['image'] = image;
    data['imagePath'] = imagePath;
    return data;
  }
}
