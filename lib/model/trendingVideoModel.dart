class TrendingVideo {
  String? msg;
  List<TrendingData>? data;
  bool? success;

  TrendingVideo({this.msg, this.data, this.success});

  TrendingVideo.fromJson(Map<String, dynamic> json) {
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

class TrendingData {
  int? id;
  String? songId;
  String? audioId;
  String? userId;
  String? screenshot;
  String? hashtags;
  String? video;
  int? isComment;
  String? description;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  bool? isLike;
  int? isSaved;
  int? isReported;
  bool? isYou;
  User? user;

  TrendingData(
      {this.id,
      this.songId,
      this.audioId,
      this.userId,
      this.screenshot,
      this.hashtags,
      this.video,
      this.isComment,
      this.description,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.isYou,
      this.user});

  TrendingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    songId = json['song_id'];
    audioId = json['audio_id'];
    userId = json['user_id'];
    screenshot = json['screenshot'];
    hashtags = json['hashtags'];
    video = json['video'];
    isComment = json['is_comment'];
    description = json['description'] ?? "";
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    isYou = json['isYou'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['song_id'] = songId;
    data['audio_id'] = audioId;
    data['user_id'] = userId;
    data['screenshot'] = screenshot;
    data['hashtags'] = hashtags;
    data['video'] = video;
    data['is_comment'] = isComment;
    data['description'] = description ?? '';
    data['imagePath'] = imagePath;
    data['originalAudio'] = originalAudio;
    data['commentCount'] = commentCount;
    data['likeCount'] = likeCount;
    data['viewCount'] = viewCount;
    data['isLike'] = isLike;
    data['isSaved'] = isSaved;
    data['isReported'] = isReported;
    data['isYou'] = isYou;
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
  String? followerRequest;
  int? isFollowing;
  int? isRequested;
  int? isCommentBlock;

  User(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.imagePath,
        this.followerRequest,

        this.isFollowing,
      this.isRequested,
      this.isCommentBlock});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
    followerRequest = json['follower_request']?.toString();
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
    data['follower_request'] = followerRequest;
    data['isFollowing'] = isFollowing;
    data['isRequested'] = isRequested;
    data['isCommentBlock'] = isCommentBlock;
    return data;
  }
}
