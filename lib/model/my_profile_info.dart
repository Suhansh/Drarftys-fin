class MyProfileInformation {
  String? msg;
  Data? data;
  bool? success;

  MyProfileInformation({this.msg, this.data, this.success});

  MyProfileInformation.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? userId;
  String? image;
  String? email;
  String? code;
  String? phone;
  String? bdate;
  String? gender;
  String? bio;
  int? status;
  int? isVerify;
  String? platform;
  String? provider;
  int? followerRequest;
  int? mentionNot;
  int? likeNot;
  int? commentNot;
  int? followNot;
  int? requestNot;
  String? notInterested;
  int? report;
  String? lat;
  String? lang;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;
  String? followingCount;
  int? isCommentBlock;

  Data(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.email,
      this.code,
      this.phone,
      this.bdate,
      this.gender,
      this.bio,
      this.status,
      this.isVerify,
      this.platform,
      this.provider,
      this.followerRequest,
      this.mentionNot,
      this.likeNot,
      this.commentNot,
      this.followNot,
      this.requestNot,
      this.notInterested,
      this.report,
      this.lat,
      this.lang,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.followersCount,
      this.followingCount,
      this.isCommentBlock});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    email = json['email'];
    code = json['code'];
    phone = json['phone'];
    bdate = json['bdate'];
    gender = json['gender'];
    bio = json['bio'];
    status = json['status'];
    isVerify = json['is_verify'];
    platform = json['platform'];
    provider = json['provider'];
    followerRequest = json['follower_request'];
    mentionNot = json['mention_not'];
    likeNot = json['like_not'];
    commentNot = json['comment_not'];
    followNot = json['follow_not'];
    requestNot = json['request_not'];
    notInterested = json['not_interested'];
    report = json['report'];
    lat = json['lat'];
    lang = json['lang'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    isCommentBlock = json['isCommentBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['image'] = image;
    data['email'] = email;
    data['code'] = code;
    data['phone'] = phone;
    data['bdate'] = bdate;
    data['gender'] = gender;
    data['bio'] = bio;
    data['status'] = status;
    data['is_verify'] = isVerify;
    data['platform'] = platform;
    data['provider'] = provider;
    data['follower_request'] = followerRequest;
    data['mention_not'] = mentionNot;
    data['like_not'] = likeNot;
    data['comment_not'] = commentNot;
    data['follow_not'] = followNot;
    data['request_not'] = requestNot;
    data['not_interested'] = notInterested;
    data['report'] = report;
    data['lat'] = lat;
    data['lang'] = lang;
    data['imagePath'] = imagePath;
    data['isFollowing'] = isFollowing;
    data['isRequested'] = isRequested;
    data['followersCount'] = followersCount;
    data['followingCount'] = followingCount;
    data['isCommentBlock'] = isCommentBlock;
    return data;
  }
}
