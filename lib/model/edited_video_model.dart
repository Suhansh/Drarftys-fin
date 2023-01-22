class EditedVideoModel {
  String? msg;
  Data? data;
  bool? success;

  EditedVideoModel({this.msg, this.data, this.success});

  EditedVideoModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? songId;
  String? audioId;
  String? video;
  String? description;
  String? hashtags;
  String? userTags;
  String? screenshot;
  String? language;
  String? view;
  int? isDuet;
  String? isComment;
  int? isApproved;
  String? lat;
  String? lang;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imagePath;
  String? originalAudio;
  String? commentCount;
  String? likeCount;
  String? viewCount;
  bool? isLike;
  int? isSaved;
  int? isReported;
  int? report;
  bool? isYou;

  Data(
      {this.id,
      this.userId,
      this.songId,
      this.audioId,
      this.video,
      this.description,
      this.hashtags,
      this.userTags,
      this.screenshot,
      this.language,
      this.view,
      this.isDuet,
      this.isComment,
      this.isApproved,
      this.lat,
      this.lang,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.imagePath,
      this.originalAudio,
      this.commentCount,
      this.likeCount,
      this.viewCount,
      this.isLike,
      this.isSaved,
      this.isReported,
      this.report,
      this.isYou});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    songId = json['song_id'];
    audioId = json['audio_id'];
    video = json['video'];
    description = json['description'];
    hashtags = json['hashtags'];
    userTags = json['user_tags'];
    screenshot = json['screenshot'];
    language = json['language'];
    view = json['view'];
    isDuet = json['is_duet'];
    isComment = json['is_comment'];
    isApproved = json['is_approved'];
    lat = json['lat'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imagePath = json['imagePath'];
    originalAudio = json['originalAudio'];
    commentCount = json['commentCount'];
    likeCount = json['likeCount'];
    viewCount = json['viewCount'];
    isLike = json['isLike'];
    isSaved = json['isSaved'];
    isReported = json['isReported'];
    report = json['report'];
    isYou = json['isYou'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['song_id'] = songId;
    data['audio_id'] = audioId;
    data['video'] = video;
    data['description'] = description;
    data['hashtags'] = hashtags;
    data['user_tags'] = userTags;
    data['screenshot'] = screenshot;
    data['language'] = language;
    data['view'] = view;
    data['is_duet'] = isDuet;
    data['is_comment'] = isComment;
    data['is_approved'] = isApproved;
    data['lat'] = lat;
    data['lang'] = lang;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['imagePath'] = imagePath;
    data['originalAudio'] = originalAudio;
    data['commentCount'] = commentCount;
    data['likeCount'] = likeCount;
    data['viewCount'] = viewCount;
    data['isLike'] = isLike;
    data['isSaved'] = isSaved;
    data['isReported'] = isReported;
    data['report'] = report;
    data['isYou'] = isYou;
    return data;
  }
}
