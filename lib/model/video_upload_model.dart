class VideoUpload {
  String? msg;
  Data? data;
  bool? success;

  VideoUpload({this.msg, this.data, this.success});

  VideoUpload.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? songId;
  String? language;
  String? video;
  String? screenshot;
  int? isApproved;
  String? description;
  String? hashtags;
  String? userTags;
  String? view;
  String? isComment;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  int? isLike;
  int? isSaved;
  int? isReported;
  int? report;

  Data(
      {this.userId,
      this.songId,
      this.language,
      this.video,
      this.screenshot,
      this.isApproved,
      this.description,
      this.hashtags,
      this.userTags,
      this.view,
      this.isComment,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.report});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    songId = json['song_id'];
    language = json['language'];
    video = json['video'];
    screenshot = json['screenshot'];
    isApproved = json['is_approved'];
    description = json['description'];
    hashtags = json['hashtags'];
    userTags = json['user_tags'];
    view = json['view'];
    isComment = json['is_comment'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['song_id'] = songId;
    data['language'] = language;
    data['video'] = video;
    data['screenshot'] = screenshot;
    data['is_approved'] = isApproved;
    data['description'] = description;
    data['hashtags'] = hashtags;
    data['user_tags'] = userTags;
    data['view'] = view;
    data['is_comment'] = isComment;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['imagePath'] = imagePath;
    data['originalAudio'] = originalAudio;
    data['commentCount'] = commentCount;
    data['likeCount'] = likeCount;
    data['viewCount'] = viewCount;
    data['isLike'] = isLike;
    data['isSaved'] = isSaved;
    data['isReported'] = isReported;
    data['report'] = report;
    return data;
  }
}
