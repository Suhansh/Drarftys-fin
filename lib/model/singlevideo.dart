class SingleVideo {
  String? msg;
  Data? data;
  bool? success;

  SingleVideo({this.msg, this.data, this.success});

  SingleVideo.fromJson(Map<String, dynamic> json) {
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
  String? songId;
  String? audioId;
  String? video;
  String? description;
  String? userId;
  int? isComment;
  String? view;
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

  Data(
      {this.id,
      this.songId,
      this.audioId,
      this.video,
      this.description,
      this.userId,
      this.isComment,
      this.view,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    songId = json['song_id'];
    audioId = json['audio_id'];
    video = json['video'];
    description = json['description'];
    userId = json['user_id'];
    isComment = json['is_comment'];
    view = json['view'];
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
    data['video'] = video;
    data['description'] = description;
    data['user_id'] = userId;
    data['is_comment'] = isComment;
    data['view'] = view;
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
