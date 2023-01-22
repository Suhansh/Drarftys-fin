class SingleAudio {
  String? msg;
  Data? data;
  bool? success;

  SingleAudio({this.msg, this.data, this.success});

  SingleAudio.fromJson(Map<String, dynamic> json) {
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
  String? videoId;
  String? audio;
  String? duration;
  List<AllVideos>? allVideos;
  String? imagePath;
  int? audioUsed;
  User? user;
  Video? video;

  Data(
      {this.id,
      this.userId,
      this.videoId,
      this.audio,
      this.duration,
      this.allVideos,
      this.imagePath,
      this.audioUsed,
      this.user,
      this.video});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    audio = json['audio'];
    duration = json['duration'];
    if (json['all_videos'] != null) {
      allVideos = <AllVideos>[];
      json['all_videos'].forEach((v) {
        allVideos!.add(AllVideos.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    audioUsed = json['audioUsed'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['video_id'] = videoId;
    data['audio'] = audio;
    data['duration'] = duration;
    if (allVideos != null) {
      data['all_videos'] = allVideos!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = imagePath;
    data['audioUsed'] = audioUsed;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}

class AllVideos {
  int? id;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;

  AllVideos(
      {this.id, this.screenshot, this.imagePath, this.isLike, this.viewCount});

  AllVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['is_like'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    data['is_like'] = isLike;
    data['viewCount'] = viewCount;
    return data;
  }
}

class User {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? imagePath;

  User({this.id, this.userId, this.name, this.image, this.imagePath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['imagePath'] = imagePath;
    return data;
  }
}

class Video {
  int? id;
  String? screenshot;
  String? imagePath;

  Video({this.id, this.screenshot, this.imagePath});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    return data;
  }
}
