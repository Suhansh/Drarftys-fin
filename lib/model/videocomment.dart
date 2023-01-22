class VideoComment {
  String? msg;
  List<CommentData>? data;
  bool? success;

  VideoComment({this.msg, this.data, this.success});

  VideoComment.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(CommentData.fromJson(v));
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

class CommentData {
  int? id;
  String? userId;
  String? comment;
  String? videoId;
  String? likesCount;
  int? isLike;
  bool showwhite = true;
  bool showred = false;
  int? isReported;
  int? canDelete;
  User? user;

  CommentData(
      {this.id,
      this.userId,
      this.comment,
      this.videoId,
      this.likesCount,
      this.isLike,
      this.isReported,
      this.canDelete,
      this.user});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    comment = json['comment'];
    videoId = json['video_id'];
    likesCount = json['likesCount'];
    isLike = json['isLike'];
    isReported = json['isReported'];
    canDelete = json['canDelete'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['comment'] = comment;
    data['video_id'] = videoId;
    data['likesCount'] = likesCount;
    data['isLike'] = isLike;
    data['isReported'] = isReported;
    data['canDelete'] = canDelete;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? imagePath;
  int? isRequested;
  int? isBlock;

  User(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.imagePath,
      this.isRequested,
      this.isBlock});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
    isRequested = json['isRequested'];
    isBlock = json['isBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['imagePath'] = imagePath;
    data['isRequested'] = isRequested;
    data['isBlock'] = isBlock;
    return data;
  }
}