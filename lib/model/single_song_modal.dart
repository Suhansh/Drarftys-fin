class MusicSingleSong {
  String? msg;
  Data? data;
  bool? success;

  MusicSingleSong({this.msg, this.data, this.success});

  MusicSingleSong.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? audio;
  String? image;
  String? artist;
  String? movie;
  int? duration;
  List<Videos>? videos;
  String? imagePath;
  int? songUsed;
  int? isFavorite;

  Data(
      {this.id,
      this.title,
      this.audio,
      this.image,
      this.artist,
      this.movie,
      this.duration,
      this.videos,
      this.imagePath,
      this.songUsed,
      this.isFavorite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    audio = json['audio'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    duration = json['duration'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    imagePath = json['imagePath'];
    songUsed = json['songUsed'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['audio'] = audio;
    data['image'] = image;
    data['artist'] = artist;
    data['movie'] = movie;
    data['duration'] = duration;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['imagePath'] = imagePath;
    data['songUsed'] = songUsed;
    data['isFavorite'] = isFavorite;
    return data;
  }
}

class Videos {
  int? id;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;

  Videos(
      {this.id, this.screenshot, this.imagePath, this.isLike, this.viewCount});

  Videos.fromJson(Map<String, dynamic> json) {
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
